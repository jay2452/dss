require 'test_helper'

class DocumentsNotifierMailerTest < ActionMailer::TestCase
  test "new_doc_notification" do
    mail = DocumentsNotifierMailer.new_doc_notification
    assert_equal "New doc notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
