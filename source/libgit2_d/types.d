/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.types;


private static import core.sys.posix.sys.types;
private static import libgit2_d.cert;
private static import libgit2_d.net;
private static import libgit2_d.odb_backend;
private static import libgit2_d.remote;
private static import libgit2_d.sys.config;
private static import libgit2_d.sys.odb_backend;
private static import libgit2_d.sys.refdb_backend;
private static import libgit2_d.sys.transport;
private static import std.conv;

/**
 * @file git2/types.h
 * @brief libgit2 base & compatibility types
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Cross-platform compatibility types for off_t / time_t
 *
 * NOTE: This needs to be in a public header so that both the library
 * implementation and client applications both agree on the same types.
 * Otherwise we get undefined behavior.
 *
 * Use the "best" types that each platform provides. Currently we truncate
 * these intermediate representations for compatibility with the git ABI, but
 * if and when it changes to support 64 bit types, our code will naturally
 * adapt.
 * NOTE: These types should match those that are returned by our internal
 * stat() functions, for all platforms.
 */
version (none) {
	//_MSC_VER
	alias git_off_t = long;
	alias git_time_t = __time64_t;
} else version (MinGW) {
	//__MINGW32__
	alias git_off_t = core.sys.posix.sys.types.off64_t;
	alias git_time_t = __time64_t;
} else version (Haiku) {
	static assert(0);
	//alias git_off_t = __haiku_std_int64;
	//alias git_time_t = __haiku_std_int64;
} else {
	/* POSIX */
	/*
	 * Note: Can't use off_t since if a client program includes <sys/types.h>
	 * before us (directly or indirectly), they'll get 32 bit off_t in their client
	 * app, even though /we/ define _FILE_OFFSET_BITS=64.
	 */
	alias git_off_t = long;

	/**
	 * time in seconds from epoch
	 */
	alias git_time_t = long;
}

//public import libgit2_d.buffer;
//public import libgit2_d.oid;

/** Basic type (loose or packed) of any Git object. */
enum git_object_t
{
	/**< Object can be any of the following */
	GIT_OBJECT_ANY = -2,

	/**< Object is invalid. */
	GIT_OBJECT_INVALID = -1,

	/**< A commit object. */
	GIT_OBJECT_COMMIT = 1,

	/**< A tree (directory listing) object. */
	GIT_OBJECT_TREE = 2,

	/**< A file revision object. */
	GIT_OBJECT_BLOB = 3,

	/**< An annotated tag object. */
	GIT_OBJECT_TAG = 4,

	/**< A delta, base is given by an offset. */
	GIT_OBJECT_OFS_DELTA = 6,

	/**< A delta, base is given by object id. */
	GIT_OBJECT_REF_DELTA = 7,
}

/** An open object database handle. */
struct git_odb;

/** A custom backend in an ODB */
alias git_odb_backend = libgit2_d.sys.odb_backend.git_odb_backend;

/** An object read from the ODB */
struct git_odb_object;

/** A stream to read/write from the ODB */
alias git_odb_stream = libgit2_d.odb_backend.git_odb_stream;

/** A stream to write a packfile to the ODB */
alias git_odb_writepack = libgit2_d.odb_backend.git_odb_writepack;

/** An open refs database handle. */
struct git_refdb;

/** A custom backend for refs */
alias git_refdb_backend = libgit2_d.sys.refdb_backend.git_refdb_backend;

/**
 * Representation of an existing git repository,
 * including all its object contents
 */
struct git_repository;

/** Representation of a working tree */
struct git_worktree;

/** Representation of a generic object in a repository */
struct git_object;

/** Representation of an in-progress walk through the commits in a repo */
struct git_revwalk;

/** Parsed representation of a tag object. */
struct git_tag;

/** In-memory representation of a blob object. */
struct git_blob;

/** Parsed representation of a commit object. */
struct git_commit;

/** Representation of each one of the entries in a tree object. */
struct git_tree_entry;

/** Representation of a tree object. */
struct git_tree;

/** Constructor for in-memory trees */
struct git_treebuilder;

/** Memory representation of an index file. */
struct git_index;

/** An iterator for entries in the index. */
struct git_index_iterator;

/** An iterator for conflicts in the index. */
struct git_index_conflict_iterator;

/** Memory representation of a set of config files */
struct git_config;

/** Interface to access a configuration file */
alias git_config_backend = libgit2_d.sys.config.git_config_backend;

/** Representation of a reference log entry */
struct git_reflog_entry;

/** Representation of a reference log */
struct git_reflog;

/** Representation of a git note */
struct git_note;

/** Representation of a git packbuilder */
struct git_packbuilder;

/** Time in a signature */
struct git_time
{
	/**< time in seconds from epoch */
	.git_time_t time;

	/**< timezone offset, in minutes */
	int offset;

	/**< indicator for questionable '-0000' offsets in signature */
	char sign;
}

/** An action signature (e.g. for committers, taggers, etc) */
struct git_signature
{
	/**< full name of the author */
	char* name;

	/**< email of the author */
	char* email;

	/**< time when the action happened */
	.git_time when;
}

/** In-memory representation of a reference. */
struct git_reference;

/** Iterator for references */
alias git_reference_iterator = libgit2_d.sys.refdb_backend.git_reference_iterator;

/** Transactional interface to references */
struct git_transaction;

/** Annotated commits, the input to merge and rebase. */
struct git_annotated_commit;

/** Representation of a status collection */
struct git_status_list;

/** Representation of a rebase */
struct git_rebase;

/** Basic type of any Git reference. */
enum git_reference_t
{
	/**< Invalid reference */
	GIT_REFERENCE_INVALID = 0,

	/**< A reference that points at an object id */
	GIT_REFERENCE_DIRECT = 1,

	/**< A reference that points at another reference */
	GIT_REFERENCE_SYMBOLIC = 2,

	GIT_REFERENCE_ALL = GIT_REFERENCE_DIRECT | GIT_REFERENCE_SYMBOLIC,
}

/** Basic type of any Git branch. */
enum git_branch_t
{
	GIT_BRANCH_LOCAL = 1,
	GIT_BRANCH_REMOTE = 2,
	GIT_BRANCH_ALL = GIT_BRANCH_LOCAL | GIT_BRANCH_REMOTE,
}

/** Valid modes for index and tree entries. */
enum git_filemode_t
{
	GIT_FILEMODE_UNREADABLE = std.conv.octal!(0000000),
	GIT_FILEMODE_TREE = std.conv.octal!(40000),
	GIT_FILEMODE_BLOB = std.conv.octal!(100644),
	GIT_FILEMODE_BLOB_EXECUTABLE = std.conv.octal!(100755),
	GIT_FILEMODE_LINK = std.conv.octal!(120000),
	GIT_FILEMODE_COMMIT = std.conv.octal!(160000),
}

/**
 * A refspec specifies the mapping between remote and local reference
 * names when fetch or pushing.
 */
struct git_refspec;

/**
 * Git's idea of a remote repository. A remote can be anonymous (in
 * which case it does not have backing configuration entires).
 */
struct git_remote;

/**
 * Interface which represents a transport to communicate with a
 * remote.
 */
alias git_transport = libgit2_d.sys.transport.git_transport;

/**
 * Preparation for a push operation. Can be used to configure what to
 * push and the level of parallelism of the packfile builder.
 */
struct git_push;

/* documentation in the definition */
alias git_remote_head = libgit2_d.net.git_remote_head;
alias git_remote_callbacks = libgit2_d.remote.git_remote_callbacks;

/**
 * Parent type for `git_cert_hostkey` and `git_cert_x509`.
 */
alias git_cert = libgit2_d.cert.git_cert;

/**
 * Opaque structure representing a submodule.
 */
struct git_submodule;

/**
 * Submodule update values
 *
 * These values represent settings for the `submodule.$name.update`
 * configuration value which says how to handle `git submodule update` for
 * this submodule.  The value is usually set in the ".gitmodules" file and
 * copied to ".git/config" when the submodule is initialized.
 *
 * You can override this setting on a per-submodule basis with
 * `git_submodule_set_update()` and write the changed value to disk using
 * `git_submodule_save()`.  If you have overwritten the value, you can
 * revert it by passing `GIT_SUBMODULE_UPDATE_RESET` to the set function.
 *
 * The values are:
 *
 * - GIT_SUBMODULE_UPDATE_CHECKOUT: the default; when a submodule is
 *   updated, checkout the new detached HEAD to the submodule directory.
 * - GIT_SUBMODULE_UPDATE_REBASE: update by rebasing the current checked
 *   out branch onto the commit from the superproject.
 * - GIT_SUBMODULE_UPDATE_MERGE: update by merging the commit in the
 *   superproject into the current checkout out branch of the submodule.
 * - GIT_SUBMODULE_UPDATE_NONE: do not update this submodule even when
 *   the commit in the superproject is updated.
 * - GIT_SUBMODULE_UPDATE_DEFAULT: not used except as static initializer
 *   when we don't want any particular update rule to be specified.
 */
enum git_submodule_update_t
{
	GIT_SUBMODULE_UPDATE_CHECKOUT = 1,
	GIT_SUBMODULE_UPDATE_REBASE = 2,
	GIT_SUBMODULE_UPDATE_MERGE = 3,
	GIT_SUBMODULE_UPDATE_NONE = 4,

	GIT_SUBMODULE_UPDATE_DEFAULT = 0,
}

/**
 * Submodule ignore values
 *
 * These values represent settings for the `submodule.$name.ignore`
 * configuration value which says how deeply to look at the working
 * directory when getting submodule status.
 *
 * You can override this value in memory on a per-submodule basis with
 * `git_submodule_set_ignore()` and can write the changed value to disk
 * with `git_submodule_save()`.  If you have overwritten the value, you
 * can revert to the on disk value by using `GIT_SUBMODULE_IGNORE_RESET`.
 *
 * The values are:
 *
 * - GIT_SUBMODULE_IGNORE_UNSPECIFIED: use the submodule's configuration
 * - GIT_SUBMODULE_IGNORE_NONE: don't ignore any change - i.e. even an
 *   untracked file, will mark the submodule as dirty.  Ignored files are
 *   still ignored, of course.
 * - GIT_SUBMODULE_IGNORE_UNTRACKED: ignore untracked files; only changes
 *   to tracked files, or the index or the HEAD commit will matter.
 * - GIT_SUBMODULE_IGNORE_DIRTY: ignore changes in the working directory,
 *   only considering changes if the HEAD of submodule has moved from the
 *   value in the superproject.
 * - GIT_SUBMODULE_IGNORE_ALL: never check if the submodule is dirty
 * - GIT_SUBMODULE_IGNORE_DEFAULT: not used except as static initializer
 *   when we don't want any particular ignore rule to be specified.
 */
enum git_submodule_ignore_t
{
	/**< use the submodule's configuration */
	GIT_SUBMODULE_IGNORE_UNSPECIFIED = -1,

	/**< any change or untracked == dirty */
	GIT_SUBMODULE_IGNORE_NONE = 1,

	/**< dirty if tracked files change */
	GIT_SUBMODULE_IGNORE_UNTRACKED = 2,

	/**< only dirty if HEAD moved */
	GIT_SUBMODULE_IGNORE_DIRTY = 3,

	/**< never dirty */
	GIT_SUBMODULE_IGNORE_ALL = 4,
}

/**
 * Options for submodule recurse.
 *
 * Represent the value of `submodule.$name.fetchRecurseSubmodules`
 *
 * * GIT_SUBMODULE_RECURSE_NO    - do no recurse into submodules
 * * GIT_SUBMODULE_RECURSE_YES   - recurse into submodules
 * * GIT_SUBMODULE_RECURSE_ONDEMAND - recurse into submodules only when
 *                                    commit not already in local clone
 */
enum git_submodule_recurse_t
{
	GIT_SUBMODULE_RECURSE_NO = 0,
	GIT_SUBMODULE_RECURSE_YES = 1,
	GIT_SUBMODULE_RECURSE_ONDEMAND = 2,
}

/** A type to write in a streaming fashion, for example, for filters. */
struct git_writestream
{
	int function(.git_writestream* stream, const (char)* buffer, size_t len) write;
	int function(.git_writestream* stream) close;
	void function(.git_writestream* stream) free;
}

/** Representation of .mailmap file state. */
struct git_mailmap;

/** @} */
