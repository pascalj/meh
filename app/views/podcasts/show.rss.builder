xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @podcast.name
    xml.description ""
    xml.link podcast_url(@podcast)

    for episode in @episodes
      xml.item do
        xml.title t('.feed.title', name: @podcast.name, date: l(episode.scheduled_at.to_date))
        xml.description t('.feed.description',
          name: @podcast.name,
          date: l(episode.scheduled_at.to_date),
          time: episode.scheduled_at.strftime('%H:%m'),
          duration: episode.podcast.length,
          stream: episode.podcast.stream.name
        )
        xml.pubDate episode.finished_at.to_s(:rfc822)
        xml.link podcast_episode_url(@podcast, episode)
        xml.guid podcast_episode_url(@podcast, episode)
        xml.enclosure url: episode_file_url(episode), length: File.size(episode.path_and_filename), type: 'audio/mpeg'
      end
    end
  end
end