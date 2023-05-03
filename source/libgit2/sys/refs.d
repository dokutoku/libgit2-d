/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.refs;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/refs.h
 * @brief Low-level Git ref creation
 * @defgroup git_backend Git custom backend APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Create a new direct reference from an OID.
 *
 * Params:
 *      name = the reference name
 *      oid = the object id for a direct reference
 *      peel = the first non-tag object's OID, or null
 *
 * Returns: the created git_reference or null on error
 */
@GIT_EXTERN
libgit2.types.git_reference* git_reference__alloc(const (char)* name, const (libgit2.oid.git_oid)* oid, const (libgit2.oid.git_oid)* peel);

/**
 * Create a new symbolic reference.
 *
 * Params:
 *      name = the reference name
 *      target = the target for a symbolic reference
 *
 * Returns: the created git_reference or null on error
 */
@GIT_EXTERN
libgit2.types.git_reference* git_reference__alloc_symbolic(const (char)* name, const (char)* target);

/* @} */
