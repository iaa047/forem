module Forem
  class SubscriptionMailer < ActionMailer::Base
    default :from => Forem.email_from_address

    def topic_reply(post_id, subscriber_id)
      # only pass id to make it easier to send emails using resque
      begin
        @post = Post.find(post_id)
      rescue
        sleep 2
        @post = Forem::Post.find(post_id)
      end
      @user = Forem.user_class.find(subscriber_id)

      mail(:to => @user.email, :subject => I18n.t('forem.topic.received_reply'))
    end
  end
end
