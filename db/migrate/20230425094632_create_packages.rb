class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.string :required_r_version
      t.text :dependencies, array: true, default: []
      t.datetime :date_publication_at
      t.string :title
      t.text :authors, array: true, default: []
      t.text :maintainers, array: true, default: []
      t.string :license

      t.timestamps
    end
  end
end
