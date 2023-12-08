const { SCOPE_INSERT, SCOPE_UPDATE, SCOPE_DELETE } = require('../config');
const collection_url = '/configuration/domains';
const resource_url = id => `/configuration/domain/${id}`;
const fixture = 'collections/domain.json';
const timeout = 10E3;

module.exports = {
  id: 'domains',
  description: 'Domains',
  tests: [
    {
      description: 'Domains - Create New',
      scope: SCOPE_INSERT,
      fixture,
      timeout,
      url: collection_url,
      interceptors: [
        {
          method: 'POST',
          url: '/api/**/config/domains',
          expectRequest: (request, fixture) => {
            Object.keys(fixture).forEach(key => {
              expect(request.body).to.have.property(key)
              expect(request.body[key]).to.deep.equal(fixture[key], key)
            })
          },
          expectResponse: (response, fixture) => {
            expect(response.statusCode).to.equal(201)
          }
        }
      ]
    },
    {
      description: 'Domains - Update Existing',
      scope: SCOPE_UPDATE,
      fixture,
      timeout,
      url: resource_url,
      interceptors: [
        {
          method: '+(PATCH|PUT)',
          url: '/api/**/config/domain/**',
          expectRequest: (request, fixture) => {
            Object.keys(fixture).forEach(key => {
              expect(request.body).to.have.property(key)
              expect(request.body[key]).to.deep.equal(fixture[key], key)
            })
          },
          expectResponse: (response, fixture) => {
            expect(response.statusCode).to.equal(200)
          }
        }
      ]
    },
    {
      description: 'Domains - Delete Existing',
      scope: SCOPE_DELETE,
      fixture,
      timeout,
      url: resource_url,
      interceptors: [
        {
          method: 'DELETE', url: '/api/**/config/domain/**', expectResponse: (response, fixture) => {
            expect(response.statusCode).to.equal(200)
          }
        }
      ]
    }
  ]
};