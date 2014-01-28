class AddMissingFacebookParamsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :uid
      t.string :oauth_token
      t.string :provider
      t.datetime :oauth_expires_at
    end
  end
end
