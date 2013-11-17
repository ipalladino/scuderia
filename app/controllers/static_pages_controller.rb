class StaticPagesController < ApplicationController
  before_filter :signed_in_user, only: [:inbox]
  
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    @ferraris = Ferrari.paginate(page: params[:page])
    
    @blogs = Blog.last(2)
    
    @featured = Ferrari.last(3).sort()
    @featured = @featured.sort_by { |obj| obj.created_at }.reverse
    #debugger
    
  end
  
  def compose
    if(params[:reply_to])
      @receipt = Receipt.find(params[:reply_to])
    else
      @receipt = nil
      @recipient = User.find(params[:recipient_id])
    end
  end
  
  def inbox
    @inbox = current_user.mailbox.inbox
  end
  
  def conversation
    conversation = Conversation.find(params[:id])
    if(params[:delete])
      #conversation.destroy
      conversation.move_to_trash(current_user)
      redirect_to "/inbox"
    else
      conversation.untrash(current_user)
    end
    conversation.mark_as_read(current_user)
    @receipts = conversation.receipts_for current_user
    @conversation = conversation
  end
  
  def send_message
    #if its a reply
    if(params[:receipt])
      receipt = Receipt.find(params[:receipt])
      begin 
        current_user.reply_to_all(receipt, params[:message])
      rescue Exception => msg 
        #do nothing
        puts msg
      end
    else
    #if its not a reply, a new conversation will be created
      recipient = User.find(params[:recipient_id])
      subject = params[:subject]
      body = params[:message]
      begin 
        current_user.send_message(recipient, subject, body)
      rescue Exception => msg 
        #do nothing
        puts msg
      end
    end
    
    redirect_to "/inbox"
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end

