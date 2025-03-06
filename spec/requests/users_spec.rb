require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'POST /login' do
    let(:user) { create(:user, password: 'senha123') }
    
    context 'com credenciais válidas' do
      before do
        post '/api/login', params: { username: user.username, password: 'senha123' }
      end
      
      it 'retorna status 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'retorna um token de autenticação' do
        expect(JSON.parse(response.body)).to have_key('token')
        expect(JSON.parse(response.body)['token']).not_to be_empty
      end
    end
    
    context 'com username inválido' do
      before do
        post '/api/login', params: { username: 'usuario_inexistente', password: 'senha123' }
      end
      
      it 'retorna status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it 'retorna mensagem de erro' do
        expect(JSON.parse(response.body)).to have_key('message')
        expect(JSON.parse(response.body)['message']).to eq('Username ou senha inválidos')
      end
    end
    
    context 'com senha inválida' do
      before do
        post '/api/login', params: { username: user.username, password: 'senha_errada' }
      end
      
      it 'retorna status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it 'retorna mensagem de erro' do
        expect(JSON.parse(response.body)).to have_key('message')
        expect(JSON.parse(response.body)['message']).to eq('Username ou senha inválidos')
      end
    end
    
  end

  describe 'GET /info_user' do
    let(:user) { create(:user) }
    let(:token) { encode_token({ username: user.username }) }
    
    context 'quando autenticado' do
      context 'com usuário que tem perguntas e acertos' do
        before do
          # Atualizando as estatísticas do usuário
          user.update(questions: 20, hits: 15)
          
          # Fazendo a requisição com o token de autenticação
          get '/api/me', headers: { 'Authorization': "Bearer #{token}" }
        end
        
        it 'retorna status 200' do
          expect(response).to have_http_status(200)
        end
        
        it 'retorna as informações corretas do usuário' do
          json_response = JSON.parse(response.body)
          
          expect(json_response['placar']).to include(
            'questoes' => 20,
            'acertos' => 15,
            'porcentagem' => 75.0
          )
        end
      end
      
      context 'com usuário que não tem perguntas' do
        before do
          # Usuário sem perguntas (para testar divisão por zero)
          user.update(questions: 0, hits: 0)
          
          get '/api/me', headers: { 'Authorization': "Bearer #{token}" }
        end
        
        it 'retorna status 200' do
          expect(response).to have_http_status(200)
        end
    
      end
    end
    
    context 'quando não autenticado' do
      before do
        get '/api/me'
      end
      
      it 'retorna status não autorizado' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context 'com token inválido' do
      before do
        get '/api/me', headers: { 'Authorization': "Bearer token_invalido" }
      end
      
      it 'retorna status não autorizado' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
