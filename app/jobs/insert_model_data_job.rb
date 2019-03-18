class InsertModelDataJob < ApplicationJob
  queue_as :default
  require 'csv'

  def perform( upload_id )
    upload = Upload.find( upload_id )
    csv = CSV.open( upload.file.path, :headers => true )
    new_csv = CSV.generate do |new_csv|
      if( upload.type_of_file == 'Roles' )
        new_csv << [ 'Name', 'Status' ]
        csv.each do |row|
          role = Role.create( name: row["Name"] )
          if role.errors.messages == {}
            new_csv << [ row["Name"], 'Inserted' ]
          else
            new_csv << [ row["Name"], "Name #{role.errors.messages[:name].join}" ]
          end
        end
      elsif( upload.type_of_file == 'Track Categories' )
        role = Role.find( upload.role )
        new_csv << [ 'Name', 'Description', 'Status' ]
        csv.each do |row|
          track_category = role.track_categories.create( name: row["Name"], description: row["Description"] )
          if track_category.errors.messages == {}
            new_csv << [ row["Name"], row["Description"], 'Inserted' ]
          else
            new_csv << [ row["Name"], row["Description"], "Name #{role.errors.messages[:name].join}" ]
          end
        end
      elsif( upload.type_of_file == 'Tracks' )
        track_category = TrackCategory.find( upload.track_category )
        new_csv << [ 'Name', 'Description', 'Status' ]
        csv.each do |row|
          track = track_category.tracks.create( name: row["Name"], description: row["Description"] )
          if track.errors.messages == {}
            new_csv << [ row["Name"], row["Description"], 'Inserted' ]
          else
            new_csv << [ row["Name"], row["Description"], "Name #{track.errors.messages[:name].join}" ]
          end
        end
      elsif( upload.type_of_file == 'Levels' )
        track = Track.find( upload.track )
        new_csv << [ 'Seq. no', 'Description', 'Example behaviour', 'Example task', 'Status' ]
        csv.each do |row|
          level = track.levels.create( seq_no: row["Seq. no"], description: row["Description"], example_behaviour: row["Example behaviour"].split(/\s*,\s*/), example_task: row["Example task"].split(/\s*,\s*/) )
          if level.errors.messages == {}
            new_csv << [ row["Seq. no"], row["Description"], row["Example behaviour"], row["Example task"], 'Inserted' ]
          else
            new_csv << [ row["Seq. no"], row["Description"], row["Example behaviour"], row["Example task"], "Seq. no #{track.errors.messages[:seq_no].join}" ]
          end
        end
      end
    end
    UserMailer.with(content: new_csv).send_csv_report.deliver_now
  end
end