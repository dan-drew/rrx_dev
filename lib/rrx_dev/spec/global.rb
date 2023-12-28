module Global
  def self.included(other)
    other.let(:json_body) do
      JSON.parse(response.body, object_class: HashWithIndifferentAccess)
    end

    other.let(:json_response) do
      expect(response).to be_success
      json_body
    end

    other.let(:json_error) do
      expect(response).not_to be_success
      json_body
    end
  end
end

RSpec.configure do |config|
  config.include Global
end
