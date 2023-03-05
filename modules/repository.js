import '../external/lightning-fs-4.6.0/lightning-fs.min.js'
import '../external/isomorphic-git-1.21.0/index.umd.min.js'
import http from '../external/isomorphic-git-1.21.0/http/web/index.js'

export const repo_init = async (repository_name) => {
	// (TODO: For now, just wipe the FS every time)
	var fs = new LightningFS(repository_name, {
		wipe: true
	});
	var pfs = fs.promises;

	return {fs: fs, pfs: pfs};
}

export const repo_pull = async (state, repository_url, repository_ref, repository_dir) => {
	var fs = state.fs;
	var pfs = state.pfs;

	console.log("Creating empty directory");
	await pfs.mkdir(repository_dir);
	console.log("Created empty directory");

	console.log("Cloning repository");
	await git.clone({
		fs: fs,
		http: http,
		dir: repository_dir,
		url: repository_url,
		ref: repository_ref,
		singleBranch: true,
		depth: 1
	});
	console.log("Cloned repository");
	console.log(await pfs.readdir(repository_dir));
}