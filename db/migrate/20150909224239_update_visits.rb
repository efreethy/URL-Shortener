class UpdateVisits < ActiveRecord::Migration
  def change
    remove_column :visits, :short_url
    
    add_column :visits, :shortened_url_id, :integer
  end
end
