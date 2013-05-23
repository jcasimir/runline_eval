class Populator
  extend DataProvider::DailyMile

  def self.add_activity_list(data, user)
    user_activities = get_user_activities(user, "runkeeper")

    data["items"].each do |activity|
      activity_id = self.get_activity_id(activity["uri"])      
      fetch_run_for_user(activity, user_id) unless user_activities.include?(activity_id)
    end
  end

  def self.fetch_run_for_user(activity, user_id)
    Resque.enqueue(FetchRunData, activity, user_id)
  end

  # Extract an activity feed from a RunKeeper URI
  # ex: 'http://jsdhf,/sjhd/193'
  # => "193"
  def self.get_activity_id(uri)
    uri.split("/")[-1]
  end

  def self.create_activity(data, user)
    run = Run.fuzzy_find({user: user,
                          started_at: DateTime.parse(data["start_time"])})
    run_id = run ? run.id : nil
    Activity.create!(RunKeeperParser.to_hash(data))
  end

  private

  def self.get_user_activities(user, provider)
    @activities ||= Activity.where(user_id: user, provider: provider).pluck(:activity_id)
  end


end

