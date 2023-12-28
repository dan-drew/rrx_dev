module Spec
  class Rswag; end
end

shared_context :rswag do |auto_example: true|
  def self.auto_example!
    after do |example|
      unless response.body.empty?
        example.metadata[:response][:content] ||= { 'application/json' => { examples: {} } }
        content = example.metadata[:response][:content]['application/json']
        content[:examples][example.metadata[:description]] = JSON.parse(response.body, symbolize_names: true)
      end
    end
  end

  auto_example! if auto_example

  ##
  # Allow multiple response example in an RSwag test by combining the
  # results into a single JSON
  def self.multiple_examples!
    # Override default +run_test!+ to provide a distinguishing name for the sub-response
    def self.run_test!(name, &block) # rubocop:disable Lint/NestedMethodDefinition
      it name do |example|
        submit_request(example.metadata)
        assert_response_matches_metadata(example.metadata, &block)
        example.instance_exec(response, &block) if block_given?
      end
    end
  end
end
