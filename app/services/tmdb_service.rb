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
    
    while series_importadas < 100
      # Busca informações em inglês
      response_en = self.class.get("/tv/popular", @options.merge(
        query: { language: 'en-US', page: page }
      ))
      
      response_en['results'].each do |serie_data|
        next if Serie.exists?(id_serie: serie_data['id'])
        
        # Busca o nome e informações em português brasileiro
        detalhes_pt = obter_detalhes_serie(serie_data['id'], 'pt-BR')
        
        serie = Serie.create!(
          id_serie: serie_data['id'],
          name_pt: detalhes_pt['name'],  # Nome em português brasileiro
          original_name: serie_data['original_name'] || serie_data['name'],  # Nome original
          country: serie_data['origin_country']&.first,
          popularity: serie_data['popularity'],
          average_voting: serie_data['vote_average'],
          synopsis: detalhes_pt['overview'] || serie_data['overview'],  # Sinopse em português (quando disponível)
          url_photo: serie_data['poster_path'] ? "https://image.tmdb.org/t/p/w500#{serie_data['poster_path']}" : nil
        )
        
        importar_elenco(serie)
        series_importadas += 1
        
        break if series_importadas >= 100
      end
      
      page += 1
      break if page > response_en['total_pages'] || response_en['results'].empty?
    end
    
    series_importadas
  end

  private

  def obter_detalhes_serie(serie_id, idioma = 'en-US')
    self.class.get("/tv/#{serie_id}", @options.merge(
      query: { language: idioma }
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
