import {
  repo_init,
  repo_pull
} from './modules/repository.js';

var repository_name = 'medarot3';
var repository_url = 'https://github.com/Medabots/medarot3';
var repository_ref = 'tr_EN';
var repository_id = repository_name + '_' + repository_ref;
var repository_dir = '/' + repository_id;

var state = await repo_init(repository_name);
await repo_pull(state, repository_url, repository_ref, repository_dir);