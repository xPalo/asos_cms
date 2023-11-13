class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.boolean :has_darkmode, null: false, default: false
      t.string :default_locale, null: false, default: 'en'

      t.timestamps
    end
  end
end
