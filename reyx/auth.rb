module Reyx
    module Auth; extend self
        def user_auth_correct?(user, pwd)
            Reyx::FS.conf_open("sys-data:users.yml") do |users|
                return false unless users.keys.include? user
                return false unless users[user]['password'] == pwd
                return true
            end
        end
    end
end
