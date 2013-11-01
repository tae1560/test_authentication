class AddAuthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kakao_access_token, :string
    add_column :users, :is_validated, :boolean
  end
end
