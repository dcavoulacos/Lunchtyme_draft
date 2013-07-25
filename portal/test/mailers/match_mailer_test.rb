require 'test_helper'

class MatchMailerTest < ActionMailer::TestCase
  test "welcome" do
    mail = MatchMailer.welcome
    assert_equal "Welcome", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "match" do
    mail = MatchMailer.match
    assert_equal "Match", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
