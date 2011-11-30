class CreateDummyfiles < ActiveRecord::Migration
  def self.up
    create_table :dummyfiles do |t|
      t.string :filetype
      t.integer :size
      t.string :filename
      t.boolean :executable
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :dummyfiles
  end
end
