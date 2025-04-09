#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_SINGLE([token],[t],[JWT Token])
# ARG_OPTIONAL_SINGLE([producer],[p],[persistent://ACCOUNT/TOPIC/SUBSCRIBER])
# ARG_OPTIONAL_SINGLE([consumer],[c],[persistent://ACCOUNT/TOPIC/SUBSCRIBER])
# ARG_OPTIONAL_SINGLE([subscription],[s],[SUBSCRIBER])
# ARG_HELP([-t TOKEN -p persistent://ACCOUNT/TOPIC/SUBSCRIBER])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='tpcsh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_token=
_arg_producer=
_arg_consumer=
_arg_subscription=


print_help()
{
	printf '%s\n' "-t TOKEN -p persistent://ACCOUNT/TOPIC/SUBSCRIBER"
	printf 'Usage: %s [-t|--token <arg>] [-p|--producer <arg>] [-c|--consumer <arg>] [-s|--subscription <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-t, --token: JWT Token (no default)"
	printf '\t%s\n' "-p, --producer: persistent://ACCOUNT/TOPIC/SUBSCRIBER (no default)"
	printf '\t%s\n' "-c, --consumer: persistent://ACCOUNT/TOPIC/SUBSCRIBER (no default)"
	printf '\t%s\n' "-s, --subscription: SUBSCRIBER (no default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-t|--token)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_token="$2"
				shift
				;;
			--token=*)
				_arg_token="${_key##--token=}"
				;;
			-t*)
				_arg_token="${_key##-t}"
				;;
			-p|--producer)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_producer="$2"
				shift
				;;
			--producer=*)
				_arg_producer="${_key##--producer=}"
				;;
			-p*)
				_arg_producer="${_key##-p}"
				;;
			-c|--consumer)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_consumer="$2"
				shift
				;;
			--consumer=*)
				_arg_consumer="${_key##--consumer=}"
				;;
			-c*)
				_arg_consumer="${_key##-c}"
				;;
			-s|--subscription)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_subscription="$2"
				shift
				;;
			--subscription=*)
				_arg_subscription="${_key##--subscription=}"
				;;
			-s*)
				_arg_subscription="${_key##-s}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


echo "Value of --token: $_arg_token"
echo "Value of --producer: $_arg_producer"
echo "Value of --consumer: $_arg_consumer"
echo "Value of --subscription: $_arg_subscription"
echo "print is $_arg_print"

if [ -z "$_arg_token" ]
then
  print_help
  die
fi

if [ ! -z "$_arg_producer" ] && [ ! -z "$_arg_consumer" ]
then
  printf 'Cannot set a producer and consumer in one execution....exiting\n'
  print_help
  die
fi

if [ ! -z "$_arg_producer" ]
then
  echo "Starting producer...."
  for i in {1..10}
  do
  # persistent/ACCOUNT_NAME/ENVIRONMENT_ID/TOPIC
  ~/apache-pulsar/bin/pulsar-client --url pulsar+ssl://usa-east.eventstreams.boomi.com:6651 \
    --auth-plugin "org.apache.pulsar.client.impl.auth.AuthenticationToken" \
    --auth-params "token:$_arg_token" \
    produce $_arg_producer \
    -f $(pwd)/data/gps_iot.xml -n 1000 &
  done
fi

if [ ! -z "$_arg_consumer" ]
then
  if [ -z "$_arg_subscription" ]
  then
    echo "Subscription is required for a consume operation...exiting"
    die
  fi

  echo "Starting consumer..."
  ~/apache-pulsar/bin/pulsar-client --url pulsar+ssl://usa-east.eventstreams.boomi.com:6651 \
    --auth-plugin "org.apache.pulsar.client.impl.auth.AuthenticationToken" \
    --auth-params "token:$_arg_token" \
    consume -s "$_arg_subscription" "$_arg_consumer" \
    -n 0
fi

# ] <-- needed because of Argbash
