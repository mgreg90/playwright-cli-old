require 'spec_helper'

RSpec.describe Playwright::CLI::Utils::FileManager::FileManager, memfs: true do
  before do
    allow(described_class).to receive(:playwright_parent_dir).and_return('/Users/fakeuser')
    FileUtils.mkdir_p('/usr/local/bin')
  end

  describe "::playwright_parent_dir" do
    it "is '/Users/fakeuser'" do
      expect(described_class.playwright_parent_dir).to eq '/Users/fakeuser'
    end
  end

  context "when script name is 'my-script'" do
    subject { described_class.new(script_name: 'my-script') }
    describe "#root_dir" do
      it "is .playwright/plays/my-script" do
        expect(subject.send(:root_dir)).to eq '/Users/fakeuser/.playwright/plays/my-script'
      end
    end
    describe "#executable_file" do
      it "is .playwright/plays/my-script/my-script.rb" do
        expect(subject.send(:executable_file)).to eq '/Users/fakeuser/.playwright/plays/my-script/my-script.rb'
      end
    end
    describe "#symlink_file" do
      it "is /usr/local/bin/my-script" do
        expect(subject.send(:symlink_file)).to eq '/usr/local/bin/my-script'
      end
    end

    describe "#symlink_file_exists?" do
      context "when symlink file already exists" do
        before do
          FileUtils.touch("./my-script")
          File.symlink("./my-script", "/usr/local/bin/my-script")
        end
        it "is true" do
          expect(subject.send(:symlink_file_exists?)).to be true
        end
      end
      context "when symlink file does not already exist" do
        it "is false" do
          expect(subject.send(:symlink_file_exists?)).to be false
        end
      end
    end

    describe "#executable_file_exists?" do
      context "when executable file already exists" do
        before do
          FileUtils.mkdir_p("/Users/fakeuser/.playwright/plays/my-script")
          FileUtils.touch("/Users/fakeuser/.playwright/plays/my-script/my-script.rb")
        end
        it "is true" do
          expect(subject.send(:executable_file_exists?)).to be true
        end
      end
      context "when symlink file does not already exist" do
        it "is false" do
          expect(subject.send(:executable_file_exists?)).to be false
        end
      end
    end

    describe "::create_file_structure" do
      context "when it is not previously installed" do
        before { described_class.create_file_structure }
        it "creates a .playwright dir" do
          expect(Dir.exists?('/Users/fakeuser/.playwright')).to be true
        end
        it "creates a .playwright/plays dir" do
          expect(Dir.exists?('/Users/fakeuser/.playwright/plays')).to be true
        end
        it "creates a .playwright/config.rb file" do
          expect(File.exists?('/Users/fakeuser/.playwright/config.rb'))
        end
      end
      context "when it is previously installed" do
        before do
          described_class.create_file_structure
          File.open("/Users/fakeuser/.playwright/config.rb", 'w') do |file|
            file.write "Example Text"
          end
        end
        it "does not throw an error" do
          expect{described_class.create_file_structure}.to_not raise_error
        end
        it "does not overwrite config.rb" do
          described_class.create_file_structure
          expect(File.read("/Users/fakeuser/.playwright/config.rb")).to eq "Example Text"
        end
      end
    end

    describe "#create_script_files" do
      context "when it is not previously installed" do
        before do
          subject.send :create_script_files
        end
        it "creates the executable file" do
          expect(File.exists?("/Users/fakeuser/.playwright/plays/my-script/my-script.rb")).to be true
        end

      end
      context "when there is a non-playwright-executable" do
        before do
          FileUtils.mkdir_p('/usr/local/bin/my-script')
          allow(described_class).to receive(:all_commands_in_path).and_return(['my-script'])
        end
        it "calls display.error" do
          subject.send(:create_script_files)
          expect(subject.display).to receive(:error)
        rescue SystemExit
        end
      end
      context "when it is previously installed" do
        before do
          subject.send :create_script_files
        end
        it "asks the user to overwrite it" do
          subject.send(:create_script_files)
          expect(subject.ask).to receive(:boolean_question)
        rescue SystemExit
        end
      end
    end

    describe "#create_symlink" do
      before do
        subject.send :create_script_files
        subject.send :create_symlink
      end
      it "creates the symlink file" do
        expect(File.exists?("/usr/local/bin/my-script")).to be true
      end
      it "symlinks the symlink file" do
        expect(File.symlink?("/usr/local/bin/my-script")).to be true
      end
    end

    describe "#delete_script_files" do
      context "when there is an executable with that name, but no play" do
        before { FileUtils.touch('usr/local/bin/my-script') }
        it "calls display.error" do
          subject.send(:delete_script_files)
          expect(subject.display).to receive(:error)
        rescue SystemExit
        end
      end

      context "when there is no play with that name" do
        it "calls display.error" do
          subject.send(:delete_script_files)
          expect(subject.display).to receive(:error)
        rescue SystemExit
        end
      end
    end

  end

end