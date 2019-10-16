/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.config;


private static import libgit2_d.common;
private static import libgit2_d.config;
private static import libgit2_d.types;

/**
 * @file git2/sys/config.h
 * @brief Git config backend routines
 * @defgroup git_backend Git custom backend APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Every iterator must have this struct as its first element, so the
 * API can talk to it. You'd define your iterator as
 *
 *     struct my_iterator {
 *             .git_config_iterator parent;
 *             ...
 *     }
 *
 * and assign `iter->parent.backend` to your `git_config_backend`.
 */
struct git_config_iterator
{
	.git_config_backend* backend;
	uint flags;

	/**
	 * Return the current entry and advance the iterator. The
	 * memory belongs to the library.
	 */
	int function(libgit2_d.config.git_config_entry** entry, .git_config_iterator* iter) next;

	/**
	 * Free the iterator
	 */
	void function(.git_config_iterator* iter) free;
}

/**
 * Generic backend that implements the interface to
 * access a configuration file
 */
struct git_config_backend
{
	uint version_;
	/** True if this backend is for a snapshot */
	int readonly;
	libgit2_d.types.git_config* cfg;

	/* Open means open the file/database and parse if necessary */
	int function(.git_config_backend*, libgit2_d.config.git_config_level_t level, const (libgit2_d.types.git_repository)* repo) open;
	int function(.git_config_backend*, const (char)* key, libgit2_d.config.git_config_entry** entry) get;
	int function(.git_config_backend*, const (char)* key, const (char)* value) set;
	int function(.git_config_backend* cfg, const (char)* name, const (char)* regexp, const (char)* value) set_multivar;
	int function(.git_config_backend*, const (char)* key) del;
	int function(.git_config_backend*, const (char)* key, const (char)* regexp) del_multivar;
	int function(.git_config_iterator**,  .git_config_backend*) iterator;
	/** Produce a read-only version of this backend */
	int function(.git_config_backend**,  .git_config_backend*) snapshot;
	/**
	 * Lock this backend.
	 *
	 * Prevent any writes to the data store backing this
	 * backend. Any updates must not be visible to any other
	 * readers.
	 */
	int function(.git_config_backend*) lock;
	/**
	 * Unlock the data store backing this backend. If success is
	 * true, the changes should be committed, otherwise rolled
	 * back.
	 */
	int function(.git_config_backend*, int success) unlock;
	void function(.git_config_backend*) free;
}

enum GIT_CONFIG_BACKEND_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_config_backend GIT_CONFIG_BACKEND_INIT()

	do
	{
		.git_config_backend OUTPUT =
		{
			version_: .GIT_CONFIG_BACKEND_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_config_backend` with default values. Equivalent to
 * creating an instance with GIT_CONFIG_BACKEND_INIT.
 *
 * @param backend the `git_config_backend` struct to initialize.
 * @param version Version of struct; pass `GIT_CONFIG_BACKEND_VERSION`
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_config_init_backend(.git_config_backend* backend, uint version_);

/**
 * Add a generic config file instance to an existing config
 *
 * Note that the configuration object will free the file
 * automatically.
 *
 * Further queries on this config object will access each
 * of the config file instances in order (instances with
 * a higher priority level will be accessed first).
 *
 * @param cfg the configuration to add the file to
 * @param file the configuration file (backend) to add
 * @param level the priority level of the backend
 * @param repo optional repository to allow parsing of
 *  conditional includes
 * @param force if a config file already exists for the given
 *  priority level, replace it
 * @return 0 on success, GIT_EEXISTS when adding more than one file
 *  for a given priority level (and force_replace set to 0), or error code
 */
//GIT_EXTERN
int git_config_add_backend(libgit2_d.types.git_config* cfg, .git_config_backend* file, libgit2_d.config.git_config_level_t level, const (libgit2_d.types.git_repository)* repo, int force);

/** @} */
