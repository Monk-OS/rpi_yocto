#!/usr/bin/env python

# Prepare the build system within the extensible SDK

import sys
import os
import subprocess

def exec_watch(cmd, **options):
    """Run program with stdout shown on sys.stdout"""
    if isinstance(cmd, basestring) and not "shell" in options:
        options["shell"] = True

    process = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, **options
    )

    buf = ''
    while True:
        out = process.stdout.read(1)
        if out:
            sys.stdout.write(out)
            sys.stdout.flush()
            buf += out
        elif out == '' and process.poll() != None:
            break

    return process.returncode, buf


def main():
    if len(sys.argv) < 2:
        print('Please specify target to prepare with')
        return 1

    sdk_targets = ' '.join(sys.argv[1:]).split()
    print('Preparing SDK for %s...' % ', '.join(sdk_targets))

    ret, out = exec_watch('bitbake %s --setscene-only' % ' '.join(sdk_targets))
    if ret:
        return ret

    targetlist = []
    for target in sdk_targets:
        if ':' in target:
            target = target.split(':')[0]
        if not target in targetlist:
            targetlist.append(target)

    recipes = []
    for target in targetlist:
        try:
            out = subprocess.check_output(('bitbake -e %s' % target).split(), stderr=subprocess.STDOUT)
            for line in out.splitlines():
                if line.startswith('FILE='):
                    splitval = line.rstrip().split('=')
                    if len(splitval) > 1:
                        recipes.append(splitval[1].strip('"'))
                    break
        except subprocess.CalledProcessError as e:
            print('ERROR: Failed to get recipe for target %s:\n%s' % (target, e.output))
            return 1

    try:
        out = subprocess.check_output('bitbake %s -n' % ' '.join(sdk_targets), stderr=subprocess.STDOUT, shell=True)
        unexpected = []
        for line in out.splitlines():
            if 'Running task' in line:
                for recipe in recipes:
                    if recipe in line:
                        break
                else:
                    line = line.split('Running', 1)[-1]
                    unexpected.append(line.rstrip())
            elif 'Running setscene' in line:
                unexpected.append(line.rstrip())
    except subprocess.CalledProcessError as e:
        print('ERROR: Failed to execute dry-run:\n%s' % e.output)
        return 1

    if unexpected:
        print('ERROR: Unexpected tasks or setscene left over to be executed:')
        for line in unexpected:
            print('  ' + line)
        return 1

if __name__ == "__main__":
    try:
        ret = main()
    except Exception:
        ret = 1
        import traceback
        traceback.print_exc(5)
    sys.exit(ret)
