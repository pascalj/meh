xml.instruct! :xml, version: "1.0" 
xml.rss version: "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title @podcast.name
    xml.description ''
    xml.tag!('itunes:title', @podcast.name)
    xml.tag!('itunes:description', '')
    xml.link podcast_url(@podcast)
    xml.tag!('itunes:author', @podcast.stream.name)
    xml.tag!('itunes:image', image_url(@podcast.image.thumb('500x500#').url)) if @podcast.image_uid

    for episode in @episodes
      xml.item do
        xml.title t('.feed.title', name: @podcast.name, date: l(episode.scheduled_at.to_date))
        xml.description t('.feed.description',
          name: @podcast.name,
          date: l(episode.scheduled_at.to_date),
          time: episode.scheduled_at.strftime('%H:%M'),
          duration: episode.podcast.length,
          stream: episode.podcast.stream.name
        )
        xml.pubDate episode.finished_at.to_s(:rfc822)
        xml.link podcast_episode_url(@podcast, episode)
        xml.guid podcast_episode_url(@podcast, episode)
        xml.tag!('itunes:image', image_url(@podcast.image.thumb('500x500#').url)) if @podcast.image_uid
        xml.tag!('itunes:duration', episode.duration)
        xml.enclosure url: episode_file_url(episode), length: File.size(episode.path_and_filename), type: 'audio/mpeg'
      end
    end
  end
end