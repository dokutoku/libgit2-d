/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.commit_graph;


private static import libgit2.buffer;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/commit_graph.h
 * @brief Git commit-graph
 * @defgroup git_commit_graph Git commit-graph APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Opens a `git_commit_graph` from a path to an objects directory.
 *
 * This finds, opens, and validates the `commit-graph` file.
 *
 * Params:
 *      cgraph_out = the `git_commit_graph` struct to initialize.
 *      objects_dir = the path to a git objects directory.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_commit_graph_open(libgit2.types.git_commit_graph** cgraph_out, const (char)* objects_dir);

/**
 * Frees commit-graph data. This should only be called when memory allocated
 * using `git_commit_graph_open` is not returned to libgit2 because it was not
 * associated with the ODB through a successful call to
 * `git_odb_set_commit_graph`.
 *
 * Params:
 *      cgraph = the commit-graph object to free. If null, no action is taken.
 */
@GIT_EXTERN
void git_commit_graph_free(libgit2.types.git_commit_graph* cgraph);

/**
 * Create a new writer for `commit-graph` files.
 *
 * Params:
 *      out_ = Location to store the writer pointer.
 *      objects_info_dir = The `objects/info` directory. The `commit-graph` file will be written in this directory.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_graph_writer_new(libgit2.types.git_commit_graph_writer** out_, const (char)* objects_info_dir);

/**
 * Free the commit-graph writer and its resources.
 *
 * Params:
 *      w = The writer to free. If null no action is taken.
 */
@GIT_EXTERN
void git_commit_graph_writer_free(libgit2.types.git_commit_graph_writer* w);

/**
 * Add an `.idx` file (associated to a packfile) to the writer.
 *
 * Params:
 *      w = The writer.
 *      repo = The repository that owns the `.idx` file.
 *      idx_path = The path of an `.idx` file.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_graph_writer_add_index_file(libgit2.types.git_commit_graph_writer* w, libgit2.types.git_repository* repo, const (char)* idx_path);

/**
 * Add a revwalk to the writer. This will add all the commits from the revwalk
 * to the commit-graph.
 *
 * Params:
 *      w = The writer.
 *      walk = The git_revwalk.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_graph_writer_add_revwalk(libgit2.types.git_commit_graph_writer* w, libgit2.types.git_revwalk* walk);


/**
 * The strategy to use when adding a new set of commits to a pre-existing
 * commit-graph chain.
 */
enum git_commit_graph_split_strategy_t
{
	/**
	 * Do not split commit-graph files. The other split strategy-related option
	 * fields are ignored.
	 */
	GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE = 0,
}

//Declaration name in C language
enum
{
	GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE = .git_commit_graph_split_strategy_t.GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE,
}

/**
 * Options structure for
 * `git_commit_graph_writer_commit`/`git_commit_graph_writer_dump`.
 *
 * Initialize with `GIT_COMMIT_GRAPH_WRITER_OPTIONS_INIT`. Alternatively, you
 * can use `git_commit_graph_writer_options_init`.
 */
struct git_commit_graph_writer_options
{
	uint version_;

	/**
	 * The strategy to use when adding new commits to a pre-existing commit-graph
	 * chain.
	 */
	.git_commit_graph_split_strategy_t split_strategy;

	/**
	 * The number of commits in level N is less than X times the number of
	 * commits in level N + 1. Default is 2.
	 */
	float size_multiple;

	/**
	 * The number of commits in level N + 1 is more than C commits.
	 * Default is 64000.
	 */
	size_t max_commits;
}

enum GIT_COMMIT_GRAPH_WRITER_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_commit_graph_writer_options GIT_COMMIT_GRAPH_WRITER_OPTIONS_INIT()

	do
	{
		.git_commit_graph_writer_options OUTPUT =
		{
			version_: .GIT_COMMIT_GRAPH_WRITER_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize git_commit_graph_writer_options structure
 *
 * Initializes a `git_commit_graph_writer_options` with default values. Equivalent to
 * creating an instance with `GIT_COMMIT_GRAPH_WRITER_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_commit_graph_writer_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_COMMIT_GRAPH_WRITER_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_commit_graph_writer_options_init(.git_commit_graph_writer_options* opts, uint version_);

/**
 * Write a `commit-graph` file to a file.
 *
 * Params:
 *      w = The writer
 *      opts = Pointer to git_commit_graph_writer_options struct.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_graph_writer_commit(libgit2.types.git_commit_graph_writer* w, .git_commit_graph_writer_options* opts);

/**
 * Dump the contents of the `commit-graph` to an in-memory buffer.
 *
 * Params:
 *      buffer = Buffer where to store the contents of the `commit-graph`.
 *      w = The writer.
 *      opts = Pointer to git_commit_graph_writer_options struct.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_graph_writer_dump(libgit2.buffer.git_buf* buffer, libgit2.types.git_commit_graph_writer* w, .git_commit_graph_writer_options* opts);

/* @} */
