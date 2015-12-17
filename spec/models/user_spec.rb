require 'rails_helper'

describe User do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :pt_id }

  describe 'scopes' do
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
