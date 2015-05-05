RSpec.describe Session do
  subject(:session) { Session.create!(user: create(:user)) }

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:expires_on) }
  end

  describe 'attributes' do
    it { should have_readonly_attribute(:token) }

    it 'sets a token when created' do
      expect(session.token).to be_a String
    end

    it 'sets an expiry date when created' do
      expect(session.expires_on).to be > Time.now
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe '#alive?' do
    context 'with a valid token' do
      its(:alive?) { should eq(true) }
    end

    context 'with an expired token' do
      before do
        session.update(expires_on: 1.hour.ago)
      end

      its(:alive?) { should eq(false) }
    end
  end

  describe '#keep_alive' do
    context 'with a valid token' do
      before do
        session.update(expires_on: 5.minutes.from_now)
      end

      it 'keeps the session alive' do
        expect(session.keep_alive).to eq(true)
        expect(session.expires_on).to be > 5.minutes.from_now
      end
    end

    context 'with an expired token' do
      before do
        session.update(expires_on: 1.hour.ago)
      end

      it 'does not keep the session alive' do
        expect(session.keep_alive).to eq(false)
        expect(session.expires_on).to be < Time.now
      end
    end
  end

  describe '#generate_token' do
    it 'uses Devise#friendly_token' do
      expect(Devise).to \
          receive(:friendly_token).at_least(:once).and_call_original

      session.send(:generate_token)
    end
  end
end
