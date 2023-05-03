/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.refspec;


private static import libgit2.buffer;
private static import libgit2.net;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/refspec.h
 * @brief Git refspec attributes
 * @defgroup git_refspec Git refspec attributes
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Parse a given refspec string
 *
 * Params:
 *      refspec = a pointer to hold the refspec handle
 *      input = the refspec string
 *      is_fetch = is this a refspec for a fetch
 *
 * Returns: 0 if the refspec string could be parsed, -1 otherwise
 */
@GIT_EXTERN
int git_refspec_parse(libgit2.types.git_refspec** refspec, const (char)* input, int is_fetch);

/**
 * Free a refspec object which has been created by git_refspec_parse
 *
 * Params:
 *      refspec = the refspec object
 */
@GIT_EXTERN
void git_refspec_free(libgit2.types.git_refspec* refspec);

/**
 * Get the source specifier
 *
 * Params:
 *      refspec = the refspec
 *
 * Returns: the refspec's source specifier
 */
@GIT_EXTERN
const (char)* git_refspec_src(const (libgit2.types.git_refspec)* refspec);

/**
 * Get the destination specifier
 *
 * Params:
 *      refspec = the refspec
 *
 * Returns: the refspec's destination specifier
 */
@GIT_EXTERN
const (char)* git_refspec_dst(const (libgit2.types.git_refspec)* refspec);

/**
 * Get the refspec's string
 *
 * Params:
 *      refspec = the refspec
 *
 * Returns: s the refspec's original string
 */
@GIT_EXTERN
const (char)* git_refspec_string(const (libgit2.types.git_refspec)* refspec);

/**
 * Get the force update setting
 *
 * Params:
 *      refspec = the refspec
 *
 * Returns: 1 if force update has been set, 0 otherwise
 */
@GIT_EXTERN
int git_refspec_force(const (libgit2.types.git_refspec)* refspec);

/**
 * Get the refspec's direction.
 *
 * Params:
 *      spec = refspec
 *
 * Returns: git_direction.GIT_DIRECTION_FETCH or git_direction.GIT_DIRECTION_PUSH
 */
@GIT_EXTERN
libgit2.net.git_direction git_refspec_direction(const (libgit2.types.git_refspec)* spec);

/**
 * Check if a refspec's source descriptor matches a reference
 *
 * Params:
 *      refspec = the refspec
 *      refname = the name of the reference to check
 *
 * Returns: 1 if the refspec matches, 0 otherwise
 */
@GIT_EXTERN
int git_refspec_src_matches(const (libgit2.types.git_refspec)* refspec, const (char)* refname);

/**
 * Check if a refspec's destination descriptor matches a reference
 *
 * Params:
 *      refspec = the refspec
 *      refname = the name of the reference to check
 *
 * Returns: 1 if the refspec matches, 0 otherwise
 */
@GIT_EXTERN
int git_refspec_dst_matches(const (libgit2.types.git_refspec)* refspec, const (char)* refname);

/**
 * Transform a reference to its target following the refspec's rules
 *
 * Params:
 *      out_ = where to store the target name
 *      spec = the refspec
 *      name = the name of the reference to transform
 *
 * Returns: 0, git_error_code.GIT_EBUFS or another error
 */
@GIT_EXTERN
int git_refspec_transform(libgit2.buffer.git_buf* out_, const (libgit2.types.git_refspec)* spec, const (char)* name);

/**
 * Transform a target reference to its source reference following the refspec's
 * rules
 *
 * Params:
 *      out_ = where to store the source reference name
 *      spec = the refspec
 *      name = the name of the reference to transform
 *
 * Returns: 0, git_error_code.GIT_EBUFS or another error
 */
@GIT_EXTERN
int git_refspec_rtransform(libgit2.buffer.git_buf* out_, const (libgit2.types.git_refspec)* spec, const (char)* name);
