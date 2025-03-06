require 'rails_helper'

RSpec.describe 'Series Question', type: :request do
  describe 'GET /answer_question' do
    let(:user) { create(:user) }
    let(:token) { encode_token({ username: user.username }) }
    # Preparando o banco de dados com algumas séries e personagens
    before do
      # Criar 5 séries
      @series = create_list(:serie, 4)
      
      # Criar personagens para a primeira série
      @characters = create_list(:character, 3, serie: @series.sample)
    end
    
    it 'retorna um JSON com a estrutura esperada' do
      get '/question', headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      
      # Verificar a estrutura da resposta
      expect(json_response).to have_key('personagem')
      expect(json_response).to have_key('series')
      
      # Verificar os detalhes do personagem
      expect(json_response['personagem']).to have_key('id')
      expect(json_response['personagem']).to have_key('nome')
      
      # Verificar se temos 4 séries retornadas
      expect(json_response['series'].count).to eq(4)
      
      # Verificar a estrutura de cada série
      json_response['series'].each do |serie|
        expect(serie).to have_key('id')
        expect(serie).to have_key('nome')
        expect(serie).to have_key('nome_original')
      end
    end
    
    it 'retorna um personagem que existe no banco de dados' do
      get '/question', headers: { 'Authorization': "Bearer #{token}" }
      
      json_response = JSON.parse(response.body)
      character_id = json_response['personagem']['id']
      
      # Verificar se o ID do personagem existe no banco
      expect(Character.exists?(character_id)).to be true
    end
    
    it 'retorna 4 séries diferentes' do
      get '/question', headers: { 'Authorization': "Bearer #{token}" }
      
      json_response = JSON.parse(response.body)
      series_ids = json_response['series'].map { |s| s['id'] }
      
      # Verificar se temos 4 IDs diferentes (sem duplicatas)
      expect(series_ids.uniq.count).to eq(4)
      
      # Verificar se os IDs existem no banco
      series_ids.each do |id|
        expect(Serie.exists?(id)).to be true
      end
    end
    
    it 'retorna um personagem que pertence a uma das séries listadas' do
      get '/question', headers: { 'Authorization': "Bearer #{token}" }
      
      json_response = JSON.parse(response.body)
      character_id = json_response['personagem']['id']
      series_ids = json_response['series'].map { |s| s['id'] }
      
      character = Character.find(character_id)
      
      # Verificar se a série do personagem está entre as retornadas
      expect(series_ids).to include(character.serie_id)
    end
    
  end



  describe '#answer_question' do
    
  let(:user) {create(:user) } 
  let(:token) {encode_token({ username: user.username }) }
  let(:serie) { create(:serie) }
  let(:character) { create(:character, serie: serie) }
  let(:different_serie) { create(:serie) }
  
  before(:each) do
    # Simulando um usuário autenticado
      #allow(controller).to receive(:authorize).and_return(user)
      #allow(controller).to receive(:current_user).and_return(user)
      #controller.instance_variable_set(:@user, user)
  end

    context 'quando a resposta está correta' do
      it 'incrementa questions e hits do usuário' do
        put "/answer", headers: { 'Authorization': "Bearer #{token}" }, params: {
          personagem: { id: character.id },
          serie: { id: serie.id }
        }

        expect(user.reload.questions).to eq(1)
        expect(JSON.parse(response.body)['mensagem']).to eq('Parabéns! Você acertou!')
        expect(user.reload.hits).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'quando a resposta está incorreta' do
      it 'incrementa apenas questions do usuário' do
        put "/answer", headers: { 'Authorization': "Bearer #{token}" }, params: {
          personagem: { id: character.id },
          serie: { id: different_serie.id }
        }

        expect(user.reload.questions).to eq(1)
        expect(user.reload.hits).to eq(0)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['mensagem']).to eq("Não foi dessa vez... a resposta correta era: #{serie.original_name}")
      end
    end

    context 'quando o personagem não é encontrado' do
      it 'lança um erro de registro não encontrado' do
        put "/answer", headers: { 'Authorization': "Bearer #{token}" }, params: {
            personagem: { id: 9999 },
            serie: { id: serie.id }
          }
          expect(JSON.parse(response.body)['mensagem']).to eq("esse personagem não existe!")
      end
    end
  end

end
