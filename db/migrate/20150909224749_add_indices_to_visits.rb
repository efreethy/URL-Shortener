class AddIndicesToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :shortened_url_id
  end
end
