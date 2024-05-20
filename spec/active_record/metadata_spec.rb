# frozen_string_literal: true

RSpec.describe ActiveRecord::Metadata do
  it 'has a version number' do
    expect(ActiveRecord::Metadata::VERSION).not_to be_nil
  end
end
