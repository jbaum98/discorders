module UsersHelper
	def create_user_database
		@user.database_path = "#{Rails.root}/db/#{@user.name.gsub(' ', '_')}"
		File.open( @user.database_path, 'w+') do |f|
			f.write("database_details: \n adapter: mysql \n database: client_db_name \n username: root \n password:")
		end
	end

	def destroy_user_database
		File.delete @user.database_path
	end
end
