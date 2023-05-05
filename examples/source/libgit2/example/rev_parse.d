/*
 * libgit2 "rev-parse" example - shows how to parse revspecs
 *
 * Written by the libgit2 contributors
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */
/**
 * License: $(LINK2 https://creativecommons.org/publicdomain/zero/1.0/, CC0 1.0 Universal)
 */
module libgit2.example.rev_parse;


private static import core.stdc.stdio;
private static import core.stdc.stdlib;
private static import core.stdc.string;
private static import libgit2.example.args;
private static import libgit2.example.common;
private static import libgit2.merge;
private static import libgit2.object;
private static import libgit2.oid;
private static import libgit2.revparse;
private static import libgit2.types;

/**
 * Forward declarations for helpers.
 */
extern (C)
public struct parse_state
{
	const (char)* repodir;
	const (char)* spec;
	int not;
}

extern (C)
nothrow @nogc
public int lg2_rev_parse(libgit2.types.git_repository* repo, int argc, char** argv)

	in
	{
	}

	do
	{
		.parse_state ps = .parse_state.init;

		.parse_opts(&ps, argc, argv);

		libgit2.example.common.check_lg2(.parse_revision(repo, &ps), "Parsing", null);

		return 0;
	}

nothrow @nogc
private void usage(const (char)* message, const (char)* arg)

	in
	{
	}

	do
	{
		if ((message != null) && (arg != null)) {
			core.stdc.stdio.fprintf(core.stdc.stdio.stderr, "%s: %s\n", message, arg);
		} else if (message != null) {
			core.stdc.stdio.fprintf(core.stdc.stdio.stderr, "%s\n", message);
		}

		core.stdc.stdio.fprintf(core.stdc.stdio.stderr, "usage: rev-parse [ --option ] <args>...\n");
		core.stdc.stdlib.exit(1);
	}

nothrow @nogc
private void parse_opts(.parse_state* ps, int argc, char** argv)

	in
	{
	}

	do
	{
		libgit2.example.args.args_info args = libgit2.example.args.ARGS_INFO_INIT(argc, argv);

		for (args.pos = 1; args.pos < argc; ++args.pos) {
			const (char)* a = argv[args.pos];

			if (a[0] != '-') {
				if (ps.spec != null) {
					.usage("Too many specs", a);
				}

				ps.spec = a;
			} else if (!core.stdc.string.strcmp(a, "--not")) {
				ps.not = !ps.not;
			} else if (!libgit2.example.args.match_str_arg(&ps.repodir, &args, "--git-dir")) {
				.usage("Cannot handle argument", a);
			}
		}
	}

nothrow @nogc
private int parse_revision(libgit2.types.git_repository* repo, .parse_state* ps)

	in
	{
	}

	do
	{
		libgit2.revparse.git_revspec rs;
		libgit2.example.common.check_lg2(libgit2.revparse.git_revparse(&rs, repo, ps.spec), "Could not parse", ps.spec);

		char[libgit2.oid.GIT_OID_SHA1_HEXSIZE + 1] str;

		if ((rs.flags & libgit2.revparse.git_revspec_t.GIT_REVSPEC_SINGLE) != 0) {
			libgit2.oid.git_oid_tostr(&(str[0]), str.length, libgit2.object.git_object_id(rs.from));
			core.stdc.stdio.printf("%s\n", &(str[0]));
			libgit2.object.git_object_free(rs.from);
		} else if ((rs.flags & libgit2.revparse.git_revspec_t.GIT_REVSPEC_RANGE) != 0) {
			libgit2.oid.git_oid_tostr(&(str[0]), str.length, libgit2.object.git_object_id(rs.to));
			core.stdc.stdio.printf("%s\n", &(str[0]));
			libgit2.object.git_object_free(rs.to);

			if ((rs.flags & libgit2.revparse.git_revspec_t.GIT_REVSPEC_MERGE_BASE) != 0) {
				libgit2.oid.git_oid base;
				libgit2.example.common.check_lg2(libgit2.merge.git_merge_base(&base, repo, libgit2.object.git_object_id(rs.from), libgit2.object.git_object_id(rs.to)), "Could not find merge base", ps.spec);

				libgit2.oid.git_oid_tostr(&(str[0]), str.length, &base);
				core.stdc.stdio.printf("%s\n", &(str[0]));
			}

			libgit2.oid.git_oid_tostr(&(str[0]), str.length, libgit2.object.git_object_id(rs.from));
			core.stdc.stdio.printf("^%s\n", &(str[0]));
			libgit2.object.git_object_free(rs.from);
		} else {
			libgit2.example.common.fatal("Invalid results from git_revparse", ps.spec);
		}

		return 0;
	}
