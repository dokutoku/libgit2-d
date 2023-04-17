/*
 * libgit2 "commit" example - shows how to create a git commit
 *
 * Written by the libgit2 contributors
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
module libgit2.example.commit;


private static import core.stdc.stdio;
private static import core.stdc.string;
private static import libgit2.commit;
private static import libgit2.errors;
private static import libgit2.example.common;
private static import libgit2.index;
private static import libgit2.oid;
private static import libgit2.repository;
private static import libgit2.revparse;
private static import libgit2.signature;
private static import libgit2.tree;
private static import libgit2.types;

package:

/**
 * This example demonstrates the libgit2 commit APIs to roughly
 * simulate `git commit` with the commit message argument.
 *
 * This does not have:
 *
 * - Robust error handling
 * - Most of the `git commit` options
 *
 * This does have:
 *
 * - Example of performing a git commit with a comment
 *
 */
extern (C)
nothrow @nogc
public int lg2_commit(libgit2.types.git_repository* repo, int argc, char** argv)

	do
	{
		const (char)* opt = argv[1];
		const (char)* comment = argv[2];

		/* Validate args */
		if ((argc < 3) || (core.stdc.string.strcmp(opt, "-m") != 0)) {
			core.stdc.stdio.printf("USAGE: %s -m <comment>\n", argv[0]);

			return -1;
		}

		libgit2.types.git_object* parent = null;
		libgit2.types.git_reference* ref_ = null;
		int error = libgit2.revparse.git_revparse_ext(&parent, &ref_, repo, "HEAD");

		if (error == libgit2.errors.git_error_code.GIT_ENOTFOUND) {
			core.stdc.stdio.printf("HEAD not found. Creating first commit\n");
			error = 0;
		} else if (error != 0) {
			const (libgit2.errors.git_error)* err = libgit2.errors.git_error_last();

			if (err) {
				core.stdc.stdio.printf("ERROR %d: %s\n", err.klass, err.message);
			} else {
				core.stdc.stdio.printf("ERROR %d: no detailed info\n", error);
			}
		}

		libgit2.types.git_index* index;
		libgit2.example.common.check_lg2(libgit2.repository.git_repository_index(&index, repo), "Could not open repository index", null);
		libgit2.oid.git_oid tree_oid;
		libgit2.example.common.check_lg2(libgit2.index.git_index_write_tree(&tree_oid, index), "Could not write tree", null);
		//;
		libgit2.example.common.check_lg2(libgit2.index.git_index_write(index), "Could not write index", null);
		//;

		libgit2.types.git_tree* tree;
		libgit2.example.common.check_lg2(libgit2.tree.git_tree_lookup(&tree, repo, &tree_oid), "Error looking up tree", null);

		libgit2.types.git_signature* signature;
		libgit2.example.common.check_lg2(libgit2.signature.git_signature_default(&signature, repo), "Error creating signature", null);

		libgit2.oid.git_oid commit_oid;
		libgit2.example.common.check_lg2(libgit2.commit.git_commit_create_v(&commit_oid, repo, "HEAD", signature, signature, null, comment, tree, (parent) ? (1) : (0), parent), "Error creating commit", null);

		libgit2.index.git_index_free(index);
		libgit2.signature.git_signature_free(signature);
		libgit2.tree.git_tree_free(tree);

		return error;
	}
