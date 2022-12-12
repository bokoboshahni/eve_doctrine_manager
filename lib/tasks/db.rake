# frozen_string_literal: true

namespace :db do # rubocop:disable Metrics/BlockLength
  namespace :static do # rubocop:disable Metrics/BlockLength
    desc 'Download static data'
    task download: :environment do # rubocop:disable Metrics/BlockLength
      require 'down'
      require 'open-uri'
      require 'pastel'
      require 'tty-command'
      require 'tty-progressbar'

      pastel = Pastel.new
      error = pastel.red.detach
      success = pastel.green.detach

      checksum_url = 'https://eve-static-data-export.s3-eu-west-1.amazonaws.com/tranquility/checksum'
      checksum_path = Rails.root.join('tmp/sde-checksum.txt')

      old_checksum = File.exist?(checksum_path) ? File.read(checksum_path) : ''
      begin
        Down.download(checksum_url, destination: checksum_path)
        puts success.call("Downloaded static data checksum to #{checksum_path}")
      rescue Down::Error => e
        puts error.call("Error downloading SDE checksum: #{e.message}")
        exit(1)
      end
      new_checksum = File.read(checksum_path)

      if old_checksum == new_checksum
        puts success.call('Static data is already up to date')
        exit
      end

      archive_url = 'https://eve-static-data-export.s3-eu-west-1.amazonaws.com/tranquility/sde.zip'
      archive_path = Rails.root.join('tmp/sde.zip')
      archive_progress_format = '[:bar] :total_byte :percent ET::elapsed ETA::eta'
      archive_progress = TTY::ProgressBar.new(archive_progress_format)
      begin
        Down.download(
          archive_url,
          destination: archive_path,
          content_length_proc: lambda { |content_length|
                                 archive_progress.update(total: content_length)
                                 archive_progress.start
                               },
          progress_proc: ->(progress) { archive_progress.current = progress }
        )
        puts success.call("Downloaded static data archive to #{archive_path}")
      rescue Down::Error => e
        puts error.call("Error downloading SDE archive: #{e.message}")
        exit(1)
      end

      static_data_path = Rails.root.join('tmp/sde')
      unzip_cmd = TTY::Command.new
      unzip_cmd.run('unzip -qq sde.zip', chdir: File.dirname(archive_path), only_output_on_error: true)
      if unzip_cmd.success?
        puts success.call("Unzipped new static data update to #{static_data_path}")
      else
        puts error.call('Error unzipping static update, see output above')
        exit(1)
      end
    end

    desc 'Import static data'
    task import: :environment do # rubocop:disable Metrics/BlockLength
      # rubocop:disable Rails/SkipsModelValidations
      require 'pastel'

      pastel = Pastel.new
      error = pastel.red.detach
      success = pastel.green.detach

      sde_path = Rails.root.join('tmp/sde')

      ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
        begin
          category_data = YAML.load_file(File.join(sde_path, 'fsd/categoryIDs.yaml'))
          @category_rows = category_data.each_with_object([]) do |(id, data), rows|
            rows << {
              id:,
              name: data['name']['en'],
              published: data['published']
            }
          end
        rescue StandardError => e
          puts error.call("Error loading category data: #{e.message}")
          raise
        end

        begin
          category_results = ItemCategory.upsert_all(@category_rows)
          puts success.call("Imported #{ItemCategory.count} categories")
        rescue StandardError => e
          puts error.call("Error importing categories: #{e.message}")
          raise
        end

        begin
          group_data = YAML.load_file(File.join(sde_path, 'fsd/groupIDs.yaml'))
          @group_rows = group_data.each_with_object([]) do |(id, data), rows|
            rows << {
              id:,
              category_id: data['categoryID'],
              name: data['name']['en'],
              published: data['published']
            }
          end
        rescue StandardError => e
          puts error.call("Error loading group data: #{e.message}")
        end

        begin
          group_results = ItemGroup.upsert_all(@group_rows)
          puts success.call("Imported #{ItemGroup.count} groups")
        rescue StandardError => e
          puts error.call("Error importing groups: #{e.message}")
        end

        begin
          item_data = YAML.load_file(File.join(sde_path, 'fsd/typeIDs.yaml'))
          dogma_data = YAML.load_file(File.join(sde_path, 'fsd/typeDogma.yaml'))

          @item_rows = item_data.each_with_object([]) do |(id, data), rows|
            effects = dogma_data[id]&.fetch('dogmaEffects')
            slot = if effects&.any? { |e| e['effectID'] == 11 }
              slot = 'low'
            elsif effects&.any? { |e| e['effectID'] == 13 }
              slot = 'medium'
            elsif effects&.any? { |e| e['effectID'] == 12 }
              slot = 'high'
            elsif effects&.any? { |e| e['effectID'] == 2663 }
              slot = 'rig'
            elsif effects&.any? { |e| e['effectID'] == 3772 }
              slot = 'subsystem'
            elsif effects&.any? { |e| e['effectID'] == 6306 }
              slot = 'service'
            else
              nil
            end
            rows << {
              id:,
              group_id: data['groupID'],
              name: data['name']['en'],
              published: data['published'],
              slot: slot
            }
          end
        rescue StandardError => e
          puts error.call("Error loading item data: #{e.message}")
        end

        begin
          item_results = Item.upsert_all(@item_rows)
          puts success.call("Imported #{Item.count} items")
        rescue StandardError => e
          puts error.call("Error importing items: #{e.message}")
        end

        puts success.call('Finished importing static data')
      rescue StandardError => e
        puts error.call("Error importing static data, rolling back import: #{e.message}")
        exit(1)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    desc 'Download and import static data'
    task update: %i[download import]
  end
end
