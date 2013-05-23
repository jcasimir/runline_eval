module DataProvider
  module DailyMile
    def add_dm_activities(data, user, provider)
      user_activities = get_user_activities(user, "dailymile")

      data.each do |activity|
        next if user_activities.include?(activity["id"])
        create_dm_activities(activity, user, provider)
      end
    end

    def create_dm_activities(data, user, provider)
      Activity.create!(activity_type: data["workout"]["activity_type"].downcase,
                       duration: data["workout"]["duration"],
                       distance: data["workout"]["distance"]["value"],
                       activity_date: data["at"],
                       activity_id: data["id"],
                       provider: provider,
                       user: user)
    end
  end
end