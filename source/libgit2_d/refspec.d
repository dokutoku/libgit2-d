/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.refspec;


private static import libgit2_d.buffer;
private static import libgit2_d.net;
private static import libgit2_d.types;

/**
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
 * @param refspec a pointer to hold the refspec handle
 * @param input the refspec string
 * @param is_fetch is this a refspec for a fetch
 * @return 0 if the refspec string could be parsed, -1 otherwise
 */
//GIT_EXTERN
int git_refspec_parse(libgit2_d.types.git_refspec** refspec, const (char)* input, int is_fetch);

/**
 * Free a refspec object which has been created by git_refspec_parse
 *
 * @param refspec the refspec object
 */
//GIT_EXTERN
void git_refspec_free(libgit2_d.types.git_refspec* refspec);

/**
 * Get the source specifier
 *
 * @param refspec the refspec
 * @return the refspec's source specifier
 */
//GIT_EXTERN
const (char)* git_refspec_src(const (libgit2_d.types.git_refspec)* refspec);

/**
 * Get the destination specifier
 *
 * @param refspec the refspec
 * @return the refspec's destination specifier
 */
//GIT_EXTERN
const (char)* git_refspec_dst(const (libgit2_d.types.git_refspec)* refspec);

/**
 * Get the refspec's string
 *
 * @param refspec the refspec
 * @returns the refspec's original string
 */
//GIT_EXTERN
const (char)* git_refspec_string(const (libgit2_d.types.git_refspec)* refspec);

/**
 * Get the force update setting
 *
 * @param refspec the refspec
 * @return 1 if force update has been set, 0 otherwise
 */
//GIT_EXTERN
int git_refspec_force(const (libgit2_d.types.git_refspec)* refspec);

/**
 * Get the refspec's direction.
 *
 * @param spec refspec
 * @return git_direction.GIT_DIRECTION_FETCH or git_direction.GIT_DIRECTION_PUSH
 */
//GIT_EXTERN
libgit2_d.net.git_direction git_refspec_direction(const (libgit2_d.types.git_refspec)* spec);

/**
 * Check if a refspec's source descriptor matches a reference
 *
 * @param refspec the refspec
 * @param refname the name of the reference to check
 * @return 1 if the refspec matches, 0 otherwise
 */
//GIT_EXTERN
int git_refspec_src_matches(const (libgit2_d.types.git_refspec)* refspec, const (char)* refname);

/**
 * Check if a refspec's destination descriptor matches a reference
 *
 * @param refspec the refspec
 * @param refname the name of the reference to check
 * @return 1 if the refspec matches, 0 otherwise
 */
//GIT_EXTERN
int git_refspec_dst_matches(const (libgit2_d.types.git_refspec)* refspec, const (char)* refname);

/**
 * Transform a reference to its target following the refspec's rules
 *
 * @param out_ where to store the target name
 * @param spec the refspec
 * @param name the name of the reference to transform
 * @return 0, git_error_code.GIT_EBUFS or another error
 */
//GIT_EXTERN
int git_refspec_transform(libgit2_d.buffer.git_buf* out_, const (libgit2_d.types.git_refspec)* spec, const (char)* name);

/**
 * Transform a target reference to its source reference following the refspec's
 * rules
 *
 * @param out_ where to store the source reference name
 * @param spec the refspec
 * @param name the name of the reference to transform
 * @return 0, git_error_code.GIT_EBUFS or another error
 */
//GIT_EXTERN
int git_refspec_rtransform(libgit2_d.buffer.git_buf* out_, const (libgit2_d.types.git_refspec)* spec, const (char)* name);
