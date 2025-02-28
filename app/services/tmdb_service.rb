class TmdbService
  include HTTParty
  base_uri 'https://api.themoviedb.org/3'
  
  def initialize
    @options = {
      headers: {
        'Authorization' => "Bearer #{ENV['TMDB_API_KEY']}",
        'Content-Type' => 'application/json;charset=utf-8'
      }
    }
  end

  def importar_series
    series_importadas = 0
    page = 1
    
    while series_importadas < 2
      response = self.class.get("/tv/popular", @options.merge(
        query: { language: 'en-US', page: page }
      ))
  
      response['results'].each do |serie_data|
        next if Serie.exists?(id_serie: serie_data['id'])
        
        detalhes = obter_detalhes_serie(serie_data['id'])
        
        serie = Serie.create!(
          id_serie: serie_data['id'],
          name_pt: serie_data['name'],
          original_name: serie_data['original_name'],
          country: detalhes['origin_country']&.first,
          popularity: serie_data['popularity'],
          average_voting: serie_data['vote_average'],
          synopsis: serie_data['overview'],
          url_photo: serie_data['poster_path'] ? "https://image.tmdb.org/t/p/w500#{serie_data['poster_path']}" : nil
        )
        
        importar_elenco(serie)
        series_importadas += 1
        
        break if series_importadas >= 2
      end
      
      page += 1
    end
    
    series_importadas
  end

  private

  def obter_detalhes_serie(serie_id)
    self.class.get("/tv/#{serie_id}", @options.merge(
      query: { language: 'en-US' }
    ))
  end

  def importar_elenco(serie)
    response = self.class.get("/tv/#{serie.id_serie}/credits", @options)
    
    response['cast'].each do |ator|
      next unless ator['known_for_department'] == 'Acting'
      
      Character.create!(
        serie: serie,
        character_name: ator['character'],
        actor_name: ator['name'],
        url_photo: ator['profile_path'] ? "https://image.tmdb.org/t/p/w500#{ator['profile_path']}" : nil
      )
    end
  end
end
