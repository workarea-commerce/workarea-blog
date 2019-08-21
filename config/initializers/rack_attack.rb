class Rack::Attack
  # Ban blog comment spammers for a day when more than 10 comments are
  # posted in an hour.
  blocklist('blog/comments') do |req|
    key = [req.ip, req.cookies['user_id']].reject(&:blank?).join(':')

    Rack::Attack::Allow2Ban.filter(key, maxretry: 10, findtime: 1.hour, bantime: 1.day) do
      req.post? && req.path =~ %r{blog_entries/(.*)/comment}
    end
  end
end
