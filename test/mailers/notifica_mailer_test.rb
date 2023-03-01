require 'test_helper'

class NotificaMailerTest < ActionMailer::TestCase
  test "confirmacao" do
    mail = NotificaMailer.confirmacao
    assert_equal "Confirmacao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "permissaosala" do
    mail = NotificaMailer.permissaosala
    assert_equal "Permissaosala", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
