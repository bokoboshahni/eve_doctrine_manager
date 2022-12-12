namespace :fittings do
  desc 'Bulk import fittings from a directory'
  task import: :environment do
    require 'pastel'
    require 'tty-progressbar'

    pastel = Pastel.new
    error = pastel.red.detach
    success = pastel.green.detach

    glob = Dir.glob(File.join(ENV.fetch('DIR'), '**/*'))
    problems = {}
    progress_format = '[:bar] :percent ET::elapsed ETA::eta'
    progress = TTY::ProgressBar.new(progress_format, total: glob.count)
    progress.start
    glob.each do |file|
      Fitting.from_eft(File.readlines(file))
    rescue StandardError => e
      problems[file] = e
    ensure
      progress.advance
    end

    if problems.any?
      puts error.call("There were #{problems.count} problems during import:")
      ap problems
      exit(1)
    else
      puts success.call("Imported #{glob.count} fittings")
    end
  end
end
