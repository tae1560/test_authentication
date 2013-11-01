require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  context 'has field named' do
    it 'uid' do
      expect(User.column_names.include? "uid").to be_true
    end

    it 'provider' do
      expect(User.column_names.include? "provider").to be_true
    end

    it 'authentication_token' do
      expect(User.column_names.include? "authentication_token").to be_true
    end

    it 'kakao_access_token' do
      expect(User.column_names.include? "kakao_access_token").to be_true
    end

    it 'is_validated' do
      expect(User.column_names.include? "is_validated").to be_true
    end
  end

end
