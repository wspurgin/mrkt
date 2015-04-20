describe MktoRest::CrudLeads do
  include_context 'initialized client'

  describe '#get_leads' do
    let(:filter_type) { 'email' }
    let(:filter_values) { %w(user@example.com) }
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            id: 1,
            firstName: 'John',
            lastName: 'Snow',
            email: 'sample@exmaple.com',
            updatedAt: '2015-04-20 05:46:13',
            createdAt: '2015-04-20 05:46:13'
          }
        ],
        success: true
      }
    end
    subject { client.get_leads(filter_type, filter_values) }

    before do
      stub_request(:get, "https://#{host}/rest/v1/leads.json")
        .with(query: { filterType: filter_type, filterValues: filter_values.join(',') })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to be_success }
  end

  describe '#createupdate_leads' do
    let(:leads) do
      [
        firstName: 'John',
        lastName: 'Snow',
        email: 'sample@example.com'
      ]
    end
    let(:request_body) do
      {
        action: 'createOrUpdate',
        input: [
          {
            firstName: 'John',
            lastName: 'Snow',
            email: 'sample@example.com'
          }
        ],
        lookupField: 'email'
      }
    end
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        success: true,
        result: [
          {
            id: 1,
            status: 'created'
          }
        ]
      }
    end
    subject { client.createupdate_leads(leads, lookup_field: :email) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to be_success }
  end

  describe '#delete_leads' do
    let(:leads) { [1] }
    let(:request_body) do
      {
        input: [
          { id: 1 }
        ]
      }
    end
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          { id: 4098, status: 'deleted' }
        ],
        success: true
      }
    end
    subject { client.delete_leads(leads) }

    before do
      stub_request(:delete, "https://#{host}/rest/v1/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to be_success }
  end
end