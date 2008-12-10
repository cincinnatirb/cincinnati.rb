#                                   Hey, Emacs, I look better with -*- ruby -*-

rspec_base = File.expand_path(File.join(RAILS_ROOT,'vendor/plugins/rspec/lib'))
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)

begin
  require 'rcov/rcovtask'

  namespace 'rcov' do
    task :setup do
      rm_f "coverage"
      rm_f "coverage.data"
    end

    namespace 'unit' do
      Rcov::RcovTask.new do |t|
        t.name = "test"
        t.libs << "test"
        t.test_files = FileList['test/unit/**/*test.rb']
        t.verbose = true
        t.rcov_opts = ['-x', '^config/boot,^/Library', '--rails',
                       # '--sort', 'name',
                       '--sort', 'coverage',
                       #'--only-uncovered',
                       '--aggregate', 'coverage.data']
      end
    end

    namespace 'functional' do
      Rcov::RcovTask.new do |t|
        t.name = "test"
        t.libs << "test"
        t.test_files = FileList['test/functional/**/*test.rb']
        t.verbose = true
        t.rcov_opts = ['-x', '^config/boot,^/Library', '--rails',
                       # '--sort', 'name',
                       '--sort', 'coverage',
                       #'--only-uncovered',
                       '--aggregate', 'coverage.data']
      end
    end

    unless FileList['test/integration/**/*test.rb'].empty?
      namespace 'integration' do
        Rcov::RcovTask.new do |t|
          t.name = "test"
          t.libs << "test"
          t.test_files = FileList['test/integration/**/*test.rb']
          t.verbose = true
          t.rcov_opts = ['-x', '^config/boot,^/Library', '--rails',
                         # '--sort', 'name',
                         '--sort', 'coverage',
                         #'--only-uncovered',
                         '--aggregate', 'coverage.data']
        end
      end
    end

    if File.exist?(rspec_base)
      require 'spec/rake/spectask'
      require 'spec/translator'

      desc "Run all specs in spec directory with RCov (excluding plugin specs)"
      Spec::Rake::SpecTask.new(:spec) do |t|
        t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
        t.spec_files = FileList['spec/**/*_spec.rb']
        t.rcov = true
        t.rcov_opts = ['--exclude', 'spec,^/Library', '--rails',
                       '--sort', 'coverage',
                       '--aggregate', 'coverage.data']
      end
    end

    desc "Rcov over all different test types"
    all_tasks = [:setup, 'unit:test', 'functional:test']
    all_tasks << 'integration:test' unless FileList['test/integration/**/*test.rb'].empty?
    all_tasks << :spec if File.exist?(rspec_base)
    task :all => all_tasks
  end

  desc "Rcov over all different test types"
  task :rcov => 'rcov:all'

rescue LoadError => e
end
