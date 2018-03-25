RSpec.describe Playwright::CLI do
  it "has a version number" do
    expect(Playwright::CLI::VERSION).not_to be nil
  end
end
