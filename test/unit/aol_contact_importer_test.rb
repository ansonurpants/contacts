# -*- encoding : utf-8 -*-
dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"
require 'contacts'

class AolContactImporterTest < ContactImporterTestCase
  def setup
    super
    @account = TestAccounts[:aol]
  end

  def test_guess_importer
    assert_equal Contacts::Aol, Contacts.guess_importer('test@aol.com')
  end

  def test_guess
    return unless @account
    contacts = Contacts.guess(@account.username, @account.password)
    @account.contacts.each do |contact|
      assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
    end
  end

  def test_successful_login
    Contacts.new(:aol, @account.username, @account.password)
  end

  def test_importer_fails_with_invalid_password
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:aol, @account.username, "wrong_password")
    end
  end

  def test_importer_fails_with_blank_password
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:aol, @account.username, "")
    end
  end

  def test_importer_fails_with_blank_username
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:aol, "", @account.password)
    end
  end

  def test_fetch_contacts
    contacts = Contacts.new(:aol, @account.username, @account.password).contacts
    @account.contacts.each do |contact|
      assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
    end
  end

end
