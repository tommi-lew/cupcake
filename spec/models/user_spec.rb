require 'rails_helper'

describe User do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :pt_id }

  describe 'scopes' do
    describe '.enabled' do
      it 'returns users who are enabled' do
        create(:user, enabled: false)
        enabled_user = create(:user, enabled: true)

        expect(User.enabled).to eq([enabled_user])
      end
    end

    describe '.product' do
      it 'returns users with product role' do
        product_user = create(:user, roles: ['product', 'dev'])
        create(:user, roles: ['dev'])

        expect(User.product).to eq([product_user])
      end
    end

    describe '.developer' do
      it 'returns users with developer role' do
        developer_user = create(:user, roles: ['dev', 'product'])
        create(:user, roles: ['product'])

        expect(User.developer).to eq([developer_user])
      end
    end
  end
end
