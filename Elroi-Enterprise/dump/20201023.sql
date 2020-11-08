--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0
-- Dumped by pg_dump version 13.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS target_project;
--
-- Name: target_project; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE target_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';


ALTER DATABASE target_project OWNER TO postgres;

\connect target_project

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    email character varying(60) NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(40),
    last_name character varying(40),
    state_resident boolean NOT NULL,
    auth_phone character varying(128),
    auth_id character varying(12) NOT NULL,
    verification_code integer,
    otp_verified boolean NOT NULL,
    account_type integer NOT NULL,
    trial_start timestamp with time zone,
    trial_end timestamp with time zone,
    current_plan_end timestamp with time zone,
    is_admin boolean NOT NULL,
    is_active boolean NOT NULL,
    is_verified boolean NOT NULL,
    is_banned boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    elroi_id character varying(9)
);


ALTER TABLE public.accounts_account OWNER TO postgres;

--
-- Name: accounts_account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account_groups (
    id integer NOT NULL,
    account_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.accounts_account_groups OWNER TO postgres;

--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_groups_id_seq OWNER TO postgres;

--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_groups_id_seq OWNED BY public.accounts_account_groups.id;


--
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_id_seq OWNER TO postgres;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts_account.id;


--
-- Name: accounts_account_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account_user_permissions (
    id integer NOT NULL,
    account_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.accounts_account_user_permissions OWNER TO postgres;

--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_user_permissions_id_seq OWNER TO postgres;

--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_user_permissions_id_seq OWNED BY public.accounts_account_user_permissions.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: consumer_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumer_requests (
    id integer NOT NULL,
    elroi_id character varying(14),
    title character varying(255),
    request_type integer NOT NULL,
    description text,
    is_data_subject_name boolean NOT NULL,
    status integer NOT NULL,
    process_end_date timestamp with time zone,
    request_date timestamp with time zone,
    approved_date timestamp with time zone,
    extend_requested boolean NOT NULL,
    extend_requested_date timestamp with time zone,
    extend_requested_days integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    customer_id integer NOT NULL,
    enterprise_id integer NOT NULL
);


ALTER TABLE public.consumer_requests OWNER TO postgres;

--
-- Name: consumer_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consumer_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consumer_requests_id_seq OWNER TO postgres;

--
-- Name: consumer_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consumer_requests_id_seq OWNED BY public.consumer_requests.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: enterprise_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprise_configuration (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enterprise_id integer NOT NULL
);


ALTER TABLE public.enterprise_configuration OWNER TO postgres;

--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprise_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprise_configuration_id_seq OWNER TO postgres;

--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprise_configuration_id_seq OWNED BY public.enterprise_configuration.id;


--
-- Name: enterprise_customer_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprise_customer_configuration (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    config jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.enterprise_customer_configuration OWNER TO postgres;

--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprise_customer_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprise_customer_configuration_id_seq OWNER TO postgres;

--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprise_customer_configuration_id_seq OWNED BY public.enterprise_customer_configuration.id;


--
-- Name: otp_static_staticdevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_static_staticdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_static_staticdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE public.otp_static_staticdevice OWNER TO postgres;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_static_staticdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_static_staticdevice_id_seq OWNER TO postgres;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_static_staticdevice_id_seq OWNED BY public.otp_static_staticdevice.id;


--
-- Name: otp_static_statictoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_static_statictoken (
    id integer NOT NULL,
    token character varying(16) NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE public.otp_static_statictoken OWNER TO postgres;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_static_statictoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_static_statictoken_id_seq OWNER TO postgres;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_static_statictoken_id_seq OWNED BY public.otp_static_statictoken.id;


--
-- Name: otp_totp_totpdevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_totp_totpdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    key character varying(80) NOT NULL,
    step smallint NOT NULL,
    t0 bigint NOT NULL,
    digits smallint NOT NULL,
    tolerance smallint NOT NULL,
    drift smallint NOT NULL,
    last_t bigint NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_totp_totpdevice_digits_check CHECK ((digits >= 0)),
    CONSTRAINT otp_totp_totpdevice_step_check CHECK ((step >= 0)),
    CONSTRAINT otp_totp_totpdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0)),
    CONSTRAINT otp_totp_totpdevice_tolerance_check CHECK ((tolerance >= 0))
);


ALTER TABLE public.otp_totp_totpdevice OWNER TO postgres;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_totp_totpdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_totp_totpdevice_id_seq OWNER TO postgres;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_totp_totpdevice_id_seq OWNED BY public.otp_totp_totpdevice.id;


--
-- Name: token_blacklist_blacklistedtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_blacklistedtoken (
    id integer NOT NULL,
    blacklisted_at timestamp with time zone NOT NULL,
    token_id integer NOT NULL
);


ALTER TABLE public.token_blacklist_blacklistedtoken OWNER TO postgres;

--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_blacklist_blacklistedtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_blacklist_blacklistedtoken_id_seq OWNER TO postgres;

--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_blacklist_blacklistedtoken_id_seq OWNED BY public.token_blacklist_blacklistedtoken.id;


--
-- Name: token_blacklist_outstandingtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_outstandingtoken (
    id integer NOT NULL,
    token text NOT NULL,
    created_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL,
    user_id integer,
    jti character varying(255) NOT NULL
);


ALTER TABLE public.token_blacklist_outstandingtoken OWNER TO postgres;

--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_blacklist_outstandingtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_blacklist_outstandingtoken_id_seq OWNER TO postgres;

--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_blacklist_outstandingtoken_id_seq OWNED BY public.token_blacklist_outstandingtoken.id;


--
-- Name: user_guide; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_guide (
    id integer NOT NULL,
    title character varying(255),
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.user_guide OWNER TO postgres;

--
-- Name: user_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_guide_id_seq OWNER TO postgres;

--
-- Name: user_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_guide_id_seq OWNED BY public.user_guide.id;


--
-- Name: user_guide_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_guide_uploads (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    file character varying(100) NOT NULL,
    size integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_guide_id integer NOT NULL
);


ALTER TABLE public.user_guide_uploads OWNER TO postgres;

--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_guide_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_guide_uploads_id_seq OWNER TO postgres;

--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_guide_uploads_id_seq OWNED BY public.user_guide_uploads.id;


--
-- Name: accounts_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- Name: accounts_account_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_groups_id_seq'::regclass);


--
-- Name: accounts_account_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_user_permissions_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: consumer_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests ALTER COLUMN id SET DEFAULT nextval('public.consumer_requests_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: enterprise_configuration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration ALTER COLUMN id SET DEFAULT nextval('public.enterprise_configuration_id_seq'::regclass);


--
-- Name: enterprise_customer_configuration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration ALTER COLUMN id SET DEFAULT nextval('public.enterprise_customer_configuration_id_seq'::regclass);


--
-- Name: otp_static_staticdevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice ALTER COLUMN id SET DEFAULT nextval('public.otp_static_staticdevice_id_seq'::regclass);


--
-- Name: otp_static_statictoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken ALTER COLUMN id SET DEFAULT nextval('public.otp_static_statictoken_id_seq'::regclass);


--
-- Name: otp_totp_totpdevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice ALTER COLUMN id SET DEFAULT nextval('public.otp_totp_totpdevice_id_seq'::regclass);


--
-- Name: token_blacklist_blacklistedtoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken ALTER COLUMN id SET DEFAULT nextval('public.token_blacklist_blacklistedtoken_id_seq'::regclass);


--
-- Name: token_blacklist_outstandingtoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken ALTER COLUMN id SET DEFAULT nextval('public.token_blacklist_outstandingtoken_id_seq'::regclass);


--
-- Name: user_guide id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide ALTER COLUMN id SET DEFAULT nextval('public.user_guide_id_seq'::regclass);


--
-- Name: user_guide_uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads ALTER COLUMN id SET DEFAULT nextval('public.user_guide_uploads_id_seq'::regclass);


--
-- Data for Name: accounts_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.accounts_account VALUES (3, 'pbkdf2_sha256$150000$4S54dtZZhpfF$08wyG5y7AYvvohmjfnA5845cYNz/y+kWLTv/LodKdIw=', '2020-10-21 22:33:29.791853+03', 'dem1o@demo.com', 'dem1o@demo.com', 'Demo', 'Demo', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:33:29.934559+03', '2020-10-21 22:33:29.92554+03', '2020-10-21 22:33:29.934559+03', 'E-156C80');
INSERT INTO public.accounts_account VALUES (4, 'pbkdf2_sha256$150000$F7TOqhPbGUH0$Fq+tJp8NnDur7iw5DVMNjg3w3JnHPOxOrQ+hd0yX2Nc=', '2020-10-21 22:34:55.592015+03', 'demo1@demo.com', 'demo1@demo.com', 'Demo1', 'Demo1', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:34:55.737625+03', '2020-10-21 22:34:55.733678+03', '2020-10-21 22:34:55.737625+03', 'E-5A7BD2');
INSERT INTO public.accounts_account VALUES (5, 'pbkdf2_sha256$150000$sY2Y4aGi0PUp$RnKdrqCmxjO+/DJQhKcDg6B+V89cw3M/W9o0ddEYTdY=', '2020-10-21 22:38:47.910177+03', 'demo2@demo.com', 'demo2@demo.com', 'Demo1', 'Demo1', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:38:48.046967+03', '2020-10-21 22:38:48.043871+03', '2020-10-21 22:38:48.046967+03', 'E-DF2CA3');
INSERT INTO public.accounts_account VALUES (6, 'pbkdf2_sha256$150000$DFSbN0McVLgb$Eh+Tb9SdrW6RJtgRMzbGf3hmv80il3cHnymObzVJh8U=', '2020-10-21 22:40:40.447053+03', 'demo23@demo.com', 'demo23@demo.com', 'Demo3', 'Demo3', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:40:40.583653+03', '2020-10-21 22:40:40.581657+03', '2020-10-21 22:40:40.583653+03', 'E-4338CD');
INSERT INTO public.accounts_account VALUES (7, 'pbkdf2_sha256$150000$pT0G1aIUgly7$B3TGWr6dDa8wzNqKRY6KJ1TMUSwMbSqwMHQCwgyQub4=', '2020-10-21 22:42:20.388552+03', 'demo4@demo.com', 'demo4@demo.com', 'Demo4', 'Demo4', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:42:20.527137+03', '2020-10-21 22:42:20.525142+03', '2020-10-21 22:42:20.527137+03', 'E-01EDF7');
INSERT INTO public.accounts_account VALUES (2, 'pbkdf2_sha256$150000$QozJR5TP81nM$B1rP8EaOVs5eQrEQFguS1t0A4g0Ioe/ZDpG7WbrWxUU=', '2020-10-20 14:46:20.757969+03', 'user@example.com', 'user@example.com', 'Alex', 'Lesan', true, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, true, false, false, false, '2020-10-20 14:58:44.910756+03', '2020-10-20 14:46:20.895494+03', '2020-10-20 14:58:44.910756+03', 'E-000002');
INSERT INTO public.accounts_account VALUES (8, 'pbkdf2_sha256$150000$yVH04ZJXVWV8$oAp68WHwhb7rywJ2emtcWAgAJHukqAthYO85lK1hVds=', '2020-10-21 22:44:46.445787+03', 'demo5@demo.com', 'demo5@demo.com', 'Demo5', 'Demo5', false, NULL, '', 0, false, 1, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:44:46.596572+03', '2020-10-21 22:44:46.580426+03', '2020-10-21 22:44:46.596572+03', 'E-CCD045');
INSERT INTO public.accounts_account VALUES (9, 'pbkdf2_sha256$150000$wNT8MS361Pr7$FXEmgHD3oavbMwYj/CP9kFIkSQAqnCbw6W52OaUXBhk=', '2020-10-21 22:49:30.115965+03', 'demo6@demo.com', 'demo6@demo.com', 'Demo6', 'Demo6', false, NULL, '', 0, false, 0, NULL, NULL, NULL, false, true, false, false, false, false, '2020-10-21 22:49:30.254594+03', '2020-10-21 22:49:30.2526+03', '2020-10-21 22:49:30.254594+03', 'C-2A2093');


--
-- Data for Name: accounts_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: accounts_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.auth_permission VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO public.auth_permission VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO public.auth_permission VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO public.auth_permission VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO public.auth_permission VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO public.auth_permission VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO public.auth_permission VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO public.auth_permission VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO public.auth_permission VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO public.auth_permission VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO public.auth_permission VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO public.auth_permission VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO public.auth_permission VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO public.auth_permission VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO public.auth_permission VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO public.auth_permission VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO public.auth_permission VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO public.auth_permission VALUES (21, 'Can add user', 6, 'add_account');
INSERT INTO public.auth_permission VALUES (22, 'Can change user', 6, 'change_account');
INSERT INTO public.auth_permission VALUES (23, 'Can delete user', 6, 'delete_account');
INSERT INTO public.auth_permission VALUES (24, 'Can view user', 6, 'view_account');
INSERT INTO public.auth_permission VALUES (25, 'Can add user guide', 7, 'add_userguide');
INSERT INTO public.auth_permission VALUES (26, 'Can change user guide', 7, 'change_userguide');
INSERT INTO public.auth_permission VALUES (27, 'Can delete user guide', 7, 'delete_userguide');
INSERT INTO public.auth_permission VALUES (28, 'Can view user guide', 7, 'view_userguide');
INSERT INTO public.auth_permission VALUES (29, 'Can add customer configuration', 8, 'add_customerconfiguration');
INSERT INTO public.auth_permission VALUES (30, 'Can change customer configuration', 8, 'change_customerconfiguration');
INSERT INTO public.auth_permission VALUES (31, 'Can delete customer configuration', 8, 'delete_customerconfiguration');
INSERT INTO public.auth_permission VALUES (32, 'Can view customer configuration', 8, 'view_customerconfiguration');
INSERT INTO public.auth_permission VALUES (33, 'Can add enterprise configuration model', 9, 'add_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission VALUES (34, 'Can change enterprise configuration model', 9, 'change_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission VALUES (35, 'Can delete enterprise configuration model', 9, 'delete_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission VALUES (36, 'Can view enterprise configuration model', 9, 'view_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission VALUES (37, 'Can add consumer request', 10, 'add_consumerrequest');
INSERT INTO public.auth_permission VALUES (38, 'Can change consumer request', 10, 'change_consumerrequest');
INSERT INTO public.auth_permission VALUES (39, 'Can delete consumer request', 10, 'delete_consumerrequest');
INSERT INTO public.auth_permission VALUES (40, 'Can view consumer request', 10, 'view_consumerrequest');
INSERT INTO public.auth_permission VALUES (41, 'Can add TOTP device', 11, 'add_totpdevice');
INSERT INTO public.auth_permission VALUES (42, 'Can change TOTP device', 11, 'change_totpdevice');
INSERT INTO public.auth_permission VALUES (43, 'Can delete TOTP device', 11, 'delete_totpdevice');
INSERT INTO public.auth_permission VALUES (44, 'Can view TOTP device', 11, 'view_totpdevice');
INSERT INTO public.auth_permission VALUES (45, 'Can add static device', 12, 'add_staticdevice');
INSERT INTO public.auth_permission VALUES (46, 'Can change static device', 12, 'change_staticdevice');
INSERT INTO public.auth_permission VALUES (47, 'Can delete static device', 12, 'delete_staticdevice');
INSERT INTO public.auth_permission VALUES (48, 'Can view static device', 12, 'view_staticdevice');
INSERT INTO public.auth_permission VALUES (49, 'Can add static token', 13, 'add_statictoken');
INSERT INTO public.auth_permission VALUES (50, 'Can change static token', 13, 'change_statictoken');
INSERT INTO public.auth_permission VALUES (51, 'Can delete static token', 13, 'delete_statictoken');
INSERT INTO public.auth_permission VALUES (52, 'Can view static token', 13, 'view_statictoken');
INSERT INTO public.auth_permission VALUES (53, 'Can add blacklisted token', 14, 'add_blacklistedtoken');
INSERT INTO public.auth_permission VALUES (54, 'Can change blacklisted token', 14, 'change_blacklistedtoken');
INSERT INTO public.auth_permission VALUES (55, 'Can delete blacklisted token', 14, 'delete_blacklistedtoken');
INSERT INTO public.auth_permission VALUES (56, 'Can view blacklisted token', 14, 'view_blacklistedtoken');
INSERT INTO public.auth_permission VALUES (57, 'Can add outstanding token', 15, 'add_outstandingtoken');
INSERT INTO public.auth_permission VALUES (58, 'Can change outstanding token', 15, 'change_outstandingtoken');
INSERT INTO public.auth_permission VALUES (59, 'Can delete outstanding token', 15, 'delete_outstandingtoken');
INSERT INTO public.auth_permission VALUES (60, 'Can view outstanding token', 15, 'view_outstandingtoken');
INSERT INTO public.auth_permission VALUES (61, 'Can add user guide uploads', 16, 'add_userguideuploads');
INSERT INTO public.auth_permission VALUES (62, 'Can change user guide uploads', 16, 'change_userguideuploads');
INSERT INTO public.auth_permission VALUES (63, 'Can delete user guide uploads', 16, 'delete_userguideuploads');
INSERT INTO public.auth_permission VALUES (64, 'Can view user guide uploads', 16, 'view_userguideuploads');
INSERT INTO public.auth_permission VALUES (65, 'Can add user guide model', 17, 'add_userguidemodel');
INSERT INTO public.auth_permission VALUES (66, 'Can change user guide model', 17, 'change_userguidemodel');
INSERT INTO public.auth_permission VALUES (67, 'Can delete user guide model', 17, 'delete_userguidemodel');
INSERT INTO public.auth_permission VALUES (68, 'Can view user guide model', 17, 'view_userguidemodel');


--
-- Data for Name: consumer_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.consumer_requests VALUES (1, '919-703-8602', 'string', 1, 'string', true, 0, '2020-12-06 17:50:47.757157+02', '2020-10-22 18:50:47.757157+03', NULL, false, NULL, 0, '2020-10-22 18:50:47.757157+03', '2020-10-22 18:50:47.757157+03', 9, 8);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_content_type VALUES (1, 'admin', 'logentry');
INSERT INTO public.django_content_type VALUES (2, 'auth', 'permission');
INSERT INTO public.django_content_type VALUES (3, 'auth', 'group');
INSERT INTO public.django_content_type VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type VALUES (5, 'sessions', 'session');
INSERT INTO public.django_content_type VALUES (6, 'accounts', 'account');
INSERT INTO public.django_content_type VALUES (7, 'enterprise', 'userguide');
INSERT INTO public.django_content_type VALUES (8, 'enterprise', 'customerconfiguration');
INSERT INTO public.django_content_type VALUES (9, 'enterprise', 'enterpriseconfigurationmodel');
INSERT INTO public.django_content_type VALUES (10, 'consumer_request', 'consumerrequest');
INSERT INTO public.django_content_type VALUES (11, 'otp_totp', 'totpdevice');
INSERT INTO public.django_content_type VALUES (12, 'otp_static', 'staticdevice');
INSERT INTO public.django_content_type VALUES (13, 'otp_static', 'statictoken');
INSERT INTO public.django_content_type VALUES (14, 'token_blacklist', 'blacklistedtoken');
INSERT INTO public.django_content_type VALUES (15, 'token_blacklist', 'outstandingtoken');
INSERT INTO public.django_content_type VALUES (16, 'enterprise', 'userguideuploads');
INSERT INTO public.django_content_type VALUES (17, 'enterprise', 'userguidemodel');


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_migrations VALUES (1, 'contenttypes', '0001_initial', '2020-10-20 14:41:29.844717+03');
INSERT INTO public.django_migrations VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2020-10-20 14:41:29.864683+03');
INSERT INTO public.django_migrations VALUES (3, 'auth', '0001_initial', '2020-10-20 14:41:29.904011+03');
INSERT INTO public.django_migrations VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2020-10-20 14:41:29.953452+03');
INSERT INTO public.django_migrations VALUES (5, 'auth', '0003_alter_user_email_max_length', '2020-10-20 14:41:29.958016+03');
INSERT INTO public.django_migrations VALUES (6, 'auth', '0004_alter_user_username_opts', '2020-10-20 14:41:29.963005+03');
INSERT INTO public.django_migrations VALUES (7, 'auth', '0005_alter_user_last_login_null', '2020-10-20 14:41:29.967992+03');
INSERT INTO public.django_migrations VALUES (8, 'auth', '0006_require_contenttypes_0002', '2020-10-20 14:41:29.970037+03');
INSERT INTO public.django_migrations VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2020-10-20 14:41:29.974028+03');
INSERT INTO public.django_migrations VALUES (10, 'auth', '0008_alter_user_username_max_length', '2020-10-20 14:41:29.979016+03');
INSERT INTO public.django_migrations VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2020-10-20 14:41:29.985057+03');
INSERT INTO public.django_migrations VALUES (12, 'auth', '0010_alter_group_name_max_length', '2020-10-20 14:41:30.001048+03');
INSERT INTO public.django_migrations VALUES (13, 'auth', '0011_update_proxy_permissions', '2020-10-20 14:41:30.006078+03');
INSERT INTO public.django_migrations VALUES (14, 'accounts', '0001_initial', '2020-10-20 14:41:30.053046+03');
INSERT INTO public.django_migrations VALUES (15, 'admin', '0001_initial', '2020-10-20 14:41:30.123964+03');
INSERT INTO public.django_migrations VALUES (16, 'admin', '0002_logentry_remove_auto_add', '2020-10-20 14:41:30.146962+03');
INSERT INTO public.django_migrations VALUES (17, 'admin', '0003_logentry_add_action_flag_choices', '2020-10-20 14:41:30.153971+03');
INSERT INTO public.django_migrations VALUES (18, 'consumer_request', '0001_initial', '2020-10-20 14:41:30.169085+03');
INSERT INTO public.django_migrations VALUES (19, 'consumer_request', '0002_consumerrequest_customer', '2020-10-20 14:41:30.179057+03');
INSERT INTO public.django_migrations VALUES (20, 'consumer_request', '0003_consumerrequest_enterprise', '2020-10-20 14:41:30.19475+03');
INSERT INTO public.django_migrations VALUES (21, 'enterprise', '0001_initial', '2020-10-20 14:41:30.217068+03');
INSERT INTO public.django_migrations VALUES (22, 'enterprise', '0002_customerconfiguration', '2020-10-20 14:41:30.240976+03');
INSERT INTO public.django_migrations VALUES (23, 'enterprise', '0003_enterpriseconfigurationmodel', '2020-10-20 14:41:30.268931+03');
INSERT INTO public.django_migrations VALUES (24, 'otp_static', '0001_initial', '2020-10-20 14:41:30.308834+03');
INSERT INTO public.django_migrations VALUES (25, 'otp_static', '0002_throttling', '2020-10-20 14:41:30.362904+03');
INSERT INTO public.django_migrations VALUES (26, 'otp_totp', '0001_initial', '2020-10-20 14:41:30.382899+03');
INSERT INTO public.django_migrations VALUES (27, 'otp_totp', '0002_auto_20190420_0723', '2020-10-20 14:41:30.412822+03');
INSERT INTO public.django_migrations VALUES (28, 'sessions', '0001_initial', '2020-10-20 14:41:30.428013+03');
INSERT INTO public.django_migrations VALUES (29, 'token_blacklist', '0001_initial', '2020-10-20 14:41:30.492554+03');
INSERT INTO public.django_migrations VALUES (30, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2020-10-20 14:41:30.5145+03');
INSERT INTO public.django_migrations VALUES (31, 'token_blacklist', '0003_auto_20171017_2007', '2020-10-20 14:41:30.546414+03');
INSERT INTO public.django_migrations VALUES (32, 'token_blacklist', '0004_auto_20171017_2013', '2020-10-20 14:41:30.569349+03');
INSERT INTO public.django_migrations VALUES (33, 'token_blacklist', '0005_remove_outstandingtoken_jti', '2020-10-20 14:41:30.582372+03');
INSERT INTO public.django_migrations VALUES (34, 'token_blacklist', '0006_auto_20171017_2113', '2020-10-20 14:41:30.598272+03');
INSERT INTO public.django_migrations VALUES (35, 'token_blacklist', '0007_auto_20171017_2214', '2020-10-20 14:41:30.641156+03');
INSERT INTO public.django_migrations VALUES (36, 'accounts', '0002_auto_20201020_1445', '2020-10-20 14:46:02.970953+03');
INSERT INTO public.django_migrations VALUES (37, 'accounts', '0003_account_ce_id', '2020-10-21 15:25:58.093482+03');
INSERT INTO public.django_migrations VALUES (38, 'accounts', '0004_auto_20201021_2231', '2020-10-21 22:31:25.389432+03');
INSERT INTO public.django_migrations VALUES (39, 'enterprise', '0004_auto_20201021_2231', '2020-10-21 22:31:25.403217+03');
INSERT INTO public.django_migrations VALUES (40, 'accounts', '0005_auto_20201021_2232', '2020-10-21 22:33:05.768865+03');
INSERT INTO public.django_migrations VALUES (41, 'consumer_request', '0004_auto_20201023_1739', '2020-10-23 20:39:23.440308+03');
INSERT INTO public.django_migrations VALUES (42, 'enterprise', '0005_auto_20201023_1739', '2020-10-23 20:39:23.554124+03');
INSERT INTO public.django_migrations VALUES (44, 'enterprise', '0002_userguidemodel_owner', '2020-10-24 02:23:10.790447+03');


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprise_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enterprise_configuration VALUES (1, 'Receiving data from customer', '{"allow_email": "true", "allow_api_call": "True"}', '2020-10-20 15:00:22.959279+03', '2020-10-20 15:00:22.959279+03', 2);


--
-- Data for Name: enterprise_customer_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: otp_static_staticdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: otp_static_statictoken; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: otp_totp_totpdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: token_blacklist_blacklistedtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: token_blacklist_outstandingtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.token_blacklist_outstandingtoken VALUES (1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MDc4MCwianRpIjoiOTFjOGI2MWUyZjY2NGMwYWJlNjhiMDJhODY3NTU0ODAiLCJ1c2VyX2lkIjoyfQ.zjmg1PqQ8QgZ9Ed0xznXacU9eU0nsa15UVujLBFXIec', '2020-10-20 14:46:20.909545+03', '2020-10-21 14:46:20+03', 2, '91c8b61e2f664c0abe68b02a86755480');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MDc5MCwianRpIjoiMWI0OTViNDY0MjQ0NGI5MGI1ZjcwNjVlMjhmOGM4OTAiLCJ1c2VyX2lkIjoyfQ.1m9cvn-3NJsmWVmOdYOiECN2fndCnyleGnYk-08iUfM', '2020-10-20 14:46:30.690475+03', '2020-10-21 14:46:30+03', 2, '1b495b4642444b90b5f7065e28f8c890');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MTU0MiwianRpIjoiZjQ4NmEwYTMxZTg0NDNmZTkzYWYwYWViN2M0YTM4MzEiLCJ1c2VyX2lkIjoyfQ.2VM_7cYktwJ5ZA_rNFDx1XzbMNYNQwai3Z7-dCr7DE8', '2020-10-20 14:59:02.282198+03', '2020-10-21 14:59:02+03', 2, 'f486a0a31e8443fe93af0aeb7c4a3831');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2NzkzMywianRpIjoiOWYyNjFkN2Q4NDQwNDAwNjk3MDljZjJjMTAwNjMyNzAiLCJ1c2VyX2lkIjoyfQ.CMgr_MYjHkkmn7NNbhRTPZbfIpdyEU54C2W8W1m9K1w', '2020-10-21 14:58:53.400738+03', '2020-10-22 14:58:53+03', 2, '9f261d7d844040069709cf2c10063270');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (5, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2Nzk0MiwianRpIjoiOGVhM2U3MjA3YWI0NDI0OGJmMjUyYWU4YmE3ZmVlOGEiLCJ1c2VyX2lkIjoyfQ.iREXiUijm0zSrrtQruDVU6XTkHzZMnQIiF841Am8_NM', '2020-10-21 14:59:02.893338+03', '2020-10-22 14:59:02+03', 2, '8ea3e7207ab44248bf252ae8ba7fee8a');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (6, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODAzNSwianRpIjoiMGUyY2U1NmM0Mjg0NDY4ZWIzZDU5ZmJiNzEzZWZkNDAiLCJ1c2VyX2lkIjoyfQ.ebX-zhgZ9L7nlM2H5qyumqH0i8aNz8CN5RFthr6M814', '2020-10-21 15:00:35.893138+03', '2020-10-22 15:00:35+03', 2, '0e2ce56c4284468eb3d59fbb713efd40');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODAzOCwianRpIjoiMTcyMWNjNDJmYjA3NDk3NWEyOTUyM2JiZGY2ZDA2MGUiLCJ1c2VyX2lkIjoyfQ.OS3zefrh5AffG8WaxsTif06NkvmTiwXSK-YyC7Lyz8k', '2020-10-21 15:00:38.443521+03', '2020-10-22 15:00:38+03', 2, '1721cc42fb074975a29523bbdf6d060e');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (8, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODA4MSwianRpIjoiYTMxMzFjMGJkNDJjNDBmMWJmYmNlMzg4ZmQ3NThkMjMiLCJ1c2VyX2lkIjoyfQ.hejSNjkvalmYtmUJRGzECdDLgBFwmCs3nCz4DTqn30A', '2020-10-21 15:01:21.095943+03', '2020-10-22 15:01:21+03', 2, 'a3131c0bd42c40f1bfbce388fd758d23');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (9, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODEwNywianRpIjoiY2NlMWE2MGI3MWY4NGJiYzhkMDI2NDlhODU0ZTgzZDciLCJ1c2VyX2lkIjoyfQ.yAiRFpqw8bN28-SGqR2MxjOUER27fD2oXbD7C1ropWI', '2020-10-21 15:01:47.605557+03', '2020-10-22 15:01:47+03', 2, 'cce1a60b71f84bbc8d02649a854e83d7');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (10, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODI0NywianRpIjoiMTQ2M2M1MzM1ZTQzNDIwYWIwZWUwMDg3NGZmYzNjYzAiLCJ1c2VyX2lkIjoyfQ.fMffUDA0FFdy0-fQRB-UKztKM464Ws3kqSLI4YYebEk', '2020-10-21 15:04:07.734812+03', '2020-10-22 15:04:07+03', 2, '1463c5335e43420ab0ee00874ffc3cc0');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (11, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2OTQ5MCwianRpIjoiOGE2NmUxZGNmMGQ5NGM3ODlmZmE0YmRiOGE0ZGRjMzAiLCJ1c2VyX2lkIjoyfQ.xgev4ouEu7ON-a26nk3M4IO6-vWoULOD8N_o6wvZ1g8', '2020-10-21 15:24:50.877408+03', '2020-10-22 15:24:50+03', 2, '8a66e1dcf0d94c789ffa4bdb8a4ddc30');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (12, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzQ2NCwianRpIjoiMGJiNzQ1YzJkMzA0NDQyYmJiNmY2YzVmNTc2YTFkMDIiLCJ1c2VyX2lkIjoyfQ.Pw4T3TnN-tV1BGOFZFbYnH5Ghr2tuL6sp2eddsED3YA', '2020-10-21 16:31:04.743862+03', '2020-10-22 16:31:04+03', 2, '0bb745c2d304442bbb6f6c5f576a1d02');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (13, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzUxNywianRpIjoiOGYzMWJmMDRmYmNkNDdmYjgwNTNjNTFlMWJiM2ZkZTMiLCJ1c2VyX2lkIjoyfQ.vdATR4B31IiGGb4jgPcj2V2j4XYKSgg3UFAm1zQ55tk', '2020-10-21 16:31:57.405426+03', '2020-10-22 16:31:57+03', 2, '8f31bf04fbcd47fb8053c51e1bb3fde3');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (14, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzY5NywianRpIjoiZDBjYjEzZTc1YzA5NGM4ZjgzOTQ0NTQ4ZDJjNDEwYzkiLCJ1c2VyX2lkIjoyfQ.zWMsjqT4xm9zqwAeydA7jHTCnc0wDAD8RwUSIAH6J4Q', '2020-10-21 16:34:57.36162+03', '2020-10-22 16:34:57+03', 2, 'd0cb13e75c094c8f83944548d2c410c9');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (15, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzcxMCwianRpIjoiY2U1NDg4NzliNzU4NDIyODlmYjY1MTc3MTFlZDQzYzYiLCJ1c2VyX2lkIjoyfQ.DdlsX1R2x84S8qUnlVOnaYGIuGhw9YrRtM4tNlP4QkA', '2020-10-21 16:35:10.065195+03', '2020-10-22 16:35:10+03', 2, 'ce548879b75842289fb6517711ed43c6');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (16, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzc1OSwianRpIjoiZjRhMmFjYTkxYTlkNGE5ZmFmMzg2OGE3NTg5ODgzZWMiLCJ1c2VyX2lkIjoyfQ.em1TA9rMTj6cqwDpPRU-sCPEPU2okSDRjg15NO-pdxk', '2020-10-21 16:35:59.937277+03', '2020-10-22 16:35:59+03', 2, 'f4a2aca91a9d4a9faf3868a7589883ec');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (17, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzc5MCwianRpIjoiODc1ODZjYTJlMTY3NGUyOGFhMDczNDUwODA4MTc0ZmYiLCJ1c2VyX2lkIjoyfQ.NYO3jGwiK0bnyaFbbQE71rZAvZm2Z4PbCCkRWCYgdrc', '2020-10-21 16:36:30.366782+03', '2020-10-22 16:36:30+03', 2, '87586ca2e1674e28aa073450808174ff');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (18, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzgxNiwianRpIjoiMGMyY2NjZTQ2Yzk1NDRkZDgwNWViNjRhN2Y0MDE5ZmQiLCJ1c2VyX2lkIjoyfQ.h07Hnh2800_IVemMpiJYu2sWJOOnd1lM45ew8Hhxi2A', '2020-10-21 16:36:56.32034+03', '2020-10-22 16:36:56+03', 2, '0c2ccce46c9544dd805eb64a7f4019fd');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (19, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzgzMSwianRpIjoiNDIwMTIzOTRhYzJjNGY4Nzk3MjNiZGJhODU1OGRhZDQiLCJ1c2VyX2lkIjoyfQ.AFLrnIjh8GygkY9vs49X45D-4uO6s8fARI1OAnv2GvM', '2020-10-21 16:37:11.476939+03', '2020-10-22 16:37:11+03', 2, '42012394ac2c4f879723bdba8558dad4');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (20, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzg2NiwianRpIjoiZGU0MDgxYTcyODliNGVhYmIzZjBjOGY5YjYwNmNmNTYiLCJ1c2VyX2lkIjoyfQ.-xi543UnuQ4QNsU-P_TtqDqTJOnoUxMMcEBWgZ8wDYM', '2020-10-21 16:37:46.846359+03', '2020-10-22 16:37:46+03', 2, 'de4081a7289b4eabb3f0c8f9b606cf56');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (21, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzg4OCwianRpIjoiMjQxNTM0YjNlMzU0NDU2YzkyNDhlZTFiYWE0YjVkNjkiLCJ1c2VyX2lkIjoyfQ.nUxcYrufr4Qs_B_tY6mvteh8kSYfTeADLOFPIaJ83ug', '2020-10-21 16:38:08.550336+03', '2020-10-22 16:38:08+03', 2, '241534b3e354456c9248ee1baa4b5d69');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (22, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3NjUxOCwianRpIjoiZGJjZGE2ZTU0NmU4NGIzY2FhNjEzYjVjNjI1NzBlOTgiLCJ1c2VyX2lkIjoyfQ.nbXGSMMVnJmTzNxxvktOUNlrOBKBumk6YSDTWlnZwtg', '2020-10-21 17:21:58.844315+03', '2020-10-22 17:21:58+03', 2, 'dbcda6e546e84b3caa613b5c62570e98');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (23, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTIwOSwianRpIjoiZGNhYTc5MGQ2MDA5NDgyNzg3ODgwNGZmOTFmNTljMTQiLCJ1c2VyX2lkIjozfQ.onI4v_tQVMz6yd5TZLp03S4lzof2Bej4huYarjEYx4s', '2020-10-21 22:33:29.94854+03', '2020-10-22 22:33:29+03', 3, 'dcaa790d60094827878804ff91f59c14');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (24, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTIxMSwianRpIjoiYmFkMWQyY2MwNTczNDRkYWJhN2VkNTFjZTQ0OWJiYWYiLCJ1c2VyX2lkIjozfQ.PYXlKwTTj5DMj0Pb8B-OpUTw_HJmlaLEQ6jSAdvldw0', '2020-10-21 22:33:31.537756+03', '2020-10-22 22:33:31+03', 3, 'bad1d2cc057344daba7ed51ce449bbaf');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (25, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTI5NSwianRpIjoiN2E3NjQzODg3NjNiNGFjNTgzMDZiNDllZjRiMTE1NmEiLCJ1c2VyX2lkIjo0fQ.3kT1C9RqGlLdWisB67yXMCdG--TUYPSjBh1lULe4O6s', '2020-10-21 22:34:55.745604+03', '2020-10-22 22:34:55+03', 4, '7a764388763b4ac58306b49ef4b1156a');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (26, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOCwianRpIjoiNzczY2YwNDgwODIwNDVjNGI1NzE0MDJjN2FjNDEzNzAiLCJ1c2VyX2lkIjo1fQ.dHXXZ6q4HemsZc3lMskoJlq-8IOZtR-zMVNdQMVBcYo', '2020-10-21 22:38:48.05479+03', '2020-10-22 22:38:48+03', 5, '773cf048082045c4b571402c7ac41370');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (27, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOCwianRpIjoiODJmNTQ3NDFhM2NkNDdmODkxMjQzMmQ3NDdjMWNkMjIiLCJ1c2VyX2lkIjo1fQ.wSgoGw6ZsTZh2a-mqIhh1zBNV11fmTIak5yVOZURYh8', '2020-10-21 22:38:48.058614+03', '2020-10-22 22:38:48+03', 5, '82f54741a3cd47f8912432d747c1cd22');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (28, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOSwianRpIjoiMWVlZTFhODU1ZTRkNGVlMzgzNjA4ZmE4MjUxZTUxNWIiLCJ1c2VyX2lkIjo1fQ.lqnZq04It1-WEwIaDfHKkyTtZnyyBjSGJThbhoQzmzQ', '2020-10-21 22:38:49.457461+03', '2020-10-22 22:38:49+03', 5, '1eee1a855e4d4ee383608fa8251e515b');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (29, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MCwianRpIjoiNzFhZDQ5MDRjMzY5NDcwYjg0NmI3YjJhODM1OWM5NWIiLCJ1c2VyX2lkIjo2fQ.5VNi_q6CBu8nSHSdxmPyEWRr0TOpZlvvkgGeUfZ8Se4', '2020-10-21 22:40:40.590633+03', '2020-10-22 22:40:40+03', 6, '71ad4904c369470b846b7b2a8359c95b');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (30, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MCwianRpIjoiYWU4MDcwNzhhYTc3NGM0ZTg2MjA2YmRkZWJlMDA2ODgiLCJ1c2VyX2lkIjo2fQ.8gmylF3Cjlq05kBvuubWwDDzO4WBmBIE-z5TXMmiOuo', '2020-10-21 22:40:40.595622+03', '2020-10-22 22:40:40+03', 6, 'ae807078aa774c4e86206bddebe00688');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (31, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MiwianRpIjoiOTA3YzliNmZhZGQwNDU2OGEyNzQyN2M0N2NhNTMwNjUiLCJ1c2VyX2lkIjo2fQ.fhsN4kB0mAKDE_oFes1AYMQlqZRDwUG-tDo2Vb6uTvw', '2020-10-21 22:40:42.139529+03', '2020-10-22 22:40:42+03', 6, '907c9b6fadd04568a27427c47ca53065');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (32, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MCwianRpIjoiZjFkZGM0Y2NjZWE5NDZjOGEzNmI4ZDVmYzRiNjY0YTYiLCJ1c2VyX2lkIjo3fQ.QvTnJurEKhfagB3RbDSwnSkBW-S1FEXWJHmFYkVtOaQ', '2020-10-21 22:42:20.535116+03', '2020-10-22 22:42:20+03', 7, 'f1ddc4cccea946c8a36b8d5fc4b664a6');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (33, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MCwianRpIjoiMGQzZjUyYTU2MGZhNGUwODhlYTI0MzJmMThkYzY3ZDciLCJ1c2VyX2lkIjo3fQ.vi-MGVxlyfXhoHS9m5ANqRCFZHZjUR8EW4sVsJH2XPM', '2020-10-21 22:42:20.539105+03', '2020-10-22 22:42:20+03', 7, '0d3f52a560fa4e088ea2432f18dc67d7');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (34, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MiwianRpIjoiMTg0OGUwNGFmZmNkNGVmNGJhMWZjNWNjNzUxZjMzNzUiLCJ1c2VyX2lkIjo3fQ.nqRdyoHXVsgVlCdYlgW3qKXZ_nZAkT9VrgDIzCEfNVY', '2020-10-21 22:42:22.019403+03', '2020-10-22 22:42:22+03', 7, '1848e04affcd4ef4ba1fc5cc751f3375');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (35, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4NiwianRpIjoiYzkzMjUyMTU1OWI5NGFiZmEyYWMyZjA2ODg0M2Y3ODEiLCJ1c2VyX2lkIjo4fQ.vrS5Cn7mOhj9ynDhbPAAxp_AUTdHr9_f8z950TWQqaM', '2020-10-21 22:44:46.598506+03', '2020-10-22 22:44:46+03', 8, 'c932521559b94abfa2ac2f068843f781');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (36, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4NiwianRpIjoiY2I0OGJlZmQxZTZmNDFlZTkyM2ViOWRkMTAwNTA2MWIiLCJ1c2VyX2lkIjo4fQ.Neb1Z0ianQ-yO3M0ddevJ0Yk1VXcPsnID-iUrf7OZag', '2020-10-21 22:44:46.601529+03', '2020-10-22 22:44:46+03', 8, 'cb48befd1e6f41ee923eb9dd1005061b');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (37, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4OCwianRpIjoiNmMxNzE1YTkxMjZjNDk5MWE5OTY2Mzg2ZjUzMTM1MzIiLCJ1c2VyX2lkIjo4fQ.fsxCDMYJEEGidrtCoIbhMv6t1__OCZkVkWll6dECehY', '2020-10-21 22:44:48.031215+03', '2020-10-22 22:44:48+03', 8, '6c1715a9126c4991a9966386f5313532');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (38, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MCwianRpIjoiZjZiZTEwN2QxOWRlNDg0ODk5YmZjYzVmMGVkZDllZTYiLCJ1c2VyX2lkIjo5fQ.zTm8kfoyn0_Qd9HfbvjXiYJNgBmXp0FcoIlj_n4ZTpM', '2020-10-21 22:49:30.26756+03', '2020-10-22 22:49:30+03', 9, 'f6be107d19de484899bfcc5f0edd9ee6');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (39, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MCwianRpIjoiN2EwOTM0ZDZjMzIzNGFiM2FmMWE4MjBmYzQ3OGRjZDAiLCJ1c2VyX2lkIjo5fQ.uDLGpkmO7vvfMYd230eSlArfSQlAHHIl51DcSliYifs', '2020-10-21 22:49:30.271549+03', '2020-10-22 22:49:30+03', 9, '7a0934d6c3234ab3af1a820fc478dcd0');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (40, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MSwianRpIjoiOTNiZjIwMzlmNzQ2NGY0NmExNjk0M2UwZTcwZGM3NDQiLCJ1c2VyX2lkIjo5fQ.gbfRayzh0_tnTDtzA_AFl683TK3piFsPttYzMnm8ZZk', '2020-10-21 22:49:31.689471+03', '2020-10-22 22:49:31+03', 9, '93bf2039f7464f46a16943e0e70dc744');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (41, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzQ1NzM2NywianRpIjoiNjI3ZWFhMTAwNTNhNDNlMDgzZjJmYmJkOTAxZjUyODMiLCJ1c2VyX2lkIjoyfQ.sfrucHfhLiXvdzYH7ipp3VONDkDZnKt25DRnBwNbm9g', '2020-10-22 15:49:27.587692+03', '2020-10-23 15:49:27+03', 2, '627eaa10053a43e083f2fbbd901f5283');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (42, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzUyOTk1MSwianRpIjoiZGMyYzY1NDYyZmFmNDNlNGE1NWIwOGY3MmMyYmEwZGEiLCJ1c2VyX2lkIjoyfQ.pz_JkBnLtVO5d1_VgZ9r9PHqJjR59_OYOtQYw-PeXmc', '2020-10-23 11:59:11.547518+03', '2020-10-24 11:59:11+03', 2, 'dc2c65462faf43e4a55b08f72c2ba0da');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (43, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzUzMDM3NiwianRpIjoiNDMwZmQ2YzRmZDIwNDEzYWJiM2RjOTNlMDFjYjY0MDgiLCJ1c2VyX2lkIjoyfQ.cs7-fFjXzGl3RaE4ibBput_Lx5PKEsP2KnrtrkmnyqM', '2020-10-23 12:06:16.760205+03', '2020-10-24 12:06:16+03', 2, '430fd6c4fd20413abb3dc93e01cb6408');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (44, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU1MDQwMiwianRpIjoiMGUzNDYzMjkxYjAwNDY5ZTk2MmQ5YjMwNzQ2NzkwZjYiLCJ1c2VyX2lkIjoyfQ.322KQXux3i0a-fQyXN-_4wNSR96yeDbXiIpcFrJY9Es', '2020-10-23 17:40:02.173858+03', '2020-10-24 17:40:02+03', 2, '0e3463291b00469e962d9b30746790f6');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (45, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU2ODgwMywianRpIjoiMjFlNjQ2YzQxMjc3NGI4N2IwZDMwMzgyMzcwNmZlM2YiLCJ1c2VyX2lkIjoyfQ.c8QhZEIkramefDsezIPSCpJ3_WoGCYE2bZ6Z-pYFKQg', '2020-10-23 22:46:43.863255+03', '2020-10-24 22:46:43+03', 2, '21e646c412774b87b0d303823706fe3f');
INSERT INTO public.token_blacklist_outstandingtoken VALUES (46, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU3MTQzNywianRpIjoiZDMzNDY4Y2M1YTQwNDExN2FjZGIxMmRkZDdmNWZhODciLCJ1c2VyX2lkIjoyfQ.nzuUyesZNufEmxZpknMvflX9htZof6UjbcvwG9jP6Uw', '2020-10-23 23:30:37.417981+03', '2020-10-24 23:30:37+03', 2, 'd33468cc5a404117acdb12ddd7f5fa87');


--
-- Data for Name: user_guide; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_guide VALUES (1, 'User Guide Test', 'User guide content', '2020-10-23 21:02:42.845812+03', '2020-10-23 21:02:42.845812+03', 2);
INSERT INTO public.user_guide VALUES (2, 'User Guide Test2', 'User guide content', '2020-10-24 02:31:16.592888+03', '2020-10-24 02:31:16.592888+03', 2);
INSERT INTO public.user_guide VALUES (3, 'User Guide Test2', 'User guide content', '2020-10-24 02:42:26.355923+03', '2020-10-24 02:42:26.355923+03', 2);


--
-- Data for Name: user_guide_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_guide_uploads VALUES (1, 'Testing', 'test.png', 0, '2020-10-23 21:25:54.717344+03', 1);
INSERT INTO public.user_guide_uploads VALUES (2, 'image_2020_10_08T06_19_04_359Z.png', 'image_2020_10_08T06_19_04_359Z.png', 243020, '2020-10-23 21:29:43.381443+03', 1);


--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_groups_id_seq', 1, false);


--
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 9, true);


--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_user_permissions_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 68, true);


--
-- Name: consumer_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consumer_requests_id_seq', 1, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 17, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 44, true);


--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_configuration_id_seq', 1, true);


--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_customer_configuration_id_seq', 1, false);


--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_static_staticdevice_id_seq', 1, false);


--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_static_statictoken_id_seq', 1, false);


--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_totp_totpdevice_id_seq', 1, false);


--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_blacklistedtoken_id_seq', 1, false);


--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_outstandingtoken_id_seq', 46, true);


--
-- Name: user_guide_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_id_seq', 3, true);


--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_uploads_id_seq', 2, true);


--
-- Name: accounts_account accounts_account_auth_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_auth_phone_key UNIQUE (auth_phone);


--
-- Name: accounts_account accounts_account_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_email_key UNIQUE (email);


--
-- Name: accounts_account_groups accounts_account_groups_account_id_group_id_f64165b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_account_id_group_id_f64165b0_uniq UNIQUE (account_id, group_id);


--
-- Name: accounts_account_groups accounts_account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_pkey PRIMARY KEY (id);


--
-- Name: accounts_account accounts_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_pkey PRIMARY KEY (id);


--
-- Name: accounts_account_user_permissions accounts_account_user_pe_account_id_permission_id_9af93c14_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_user_pe_account_id_permission_id_9af93c14_uniq UNIQUE (account_id, permission_id);


--
-- Name: accounts_account_user_permissions accounts_account_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: accounts_account accounts_account_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_username_key UNIQUE (username);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: consumer_requests consumer_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: enterprise_configuration enterprise_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration
    ADD CONSTRAINT enterprise_configuration_pkey PRIMARY KEY (id);


--
-- Name: enterprise_customer_configuration enterprise_customer_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration
    ADD CONSTRAINT enterprise_customer_configuration_pkey PRIMARY KEY (id);


--
-- Name: otp_static_staticdevice otp_static_staticdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdevice_pkey PRIMARY KEY (id);


--
-- Name: otp_static_statictoken otp_static_statictoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictoken_pkey PRIMARY KEY (id);


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_token_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_token_id_key UNIQUE (token_id);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq UNIQUE (jti);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_pkey PRIMARY KEY (id);


--
-- Name: user_guide user_guide_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide
    ADD CONSTRAINT user_guide_pkey PRIMARY KEY (id);


--
-- Name: user_guide_uploads user_guide_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads
    ADD CONSTRAINT user_guide_uploads_pkey PRIMARY KEY (id);


--
-- Name: accounts_account_auth_phone_02c05d73_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_auth_phone_02c05d73_like ON public.accounts_account USING btree (auth_phone varchar_pattern_ops);


--
-- Name: accounts_account_elroi_id_3432ac3d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_elroi_id_3432ac3d ON public.accounts_account USING btree (elroi_id);


--
-- Name: accounts_account_elroi_id_3432ac3d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_elroi_id_3432ac3d_like ON public.accounts_account USING btree (elroi_id varchar_pattern_ops);


--
-- Name: accounts_account_email_348850e2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_email_348850e2_like ON public.accounts_account USING btree (email varchar_pattern_ops);


--
-- Name: accounts_account_groups_account_id_52f14852; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_groups_account_id_52f14852 ON public.accounts_account_groups USING btree (account_id);


--
-- Name: accounts_account_groups_group_id_7c6a6bd1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_groups_group_id_7c6a6bd1 ON public.accounts_account_groups USING btree (group_id);


--
-- Name: accounts_account_user_permissions_account_id_816f9bde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_user_permissions_account_id_816f9bde ON public.accounts_account_user_permissions USING btree (account_id);


--
-- Name: accounts_account_user_permissions_permission_id_24620205; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_user_permissions_permission_id_24620205 ON public.accounts_account_user_permissions USING btree (permission_id);


--
-- Name: accounts_account_username_b5f69a28_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_username_b5f69a28_like ON public.accounts_account USING btree (username varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: consumer_requests_customer_id_9915e7f1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumer_requests_customer_id_9915e7f1 ON public.consumer_requests USING btree (customer_id);


--
-- Name: consumer_requests_enterprise_id_5e899e15; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumer_requests_enterprise_id_5e899e15 ON public.consumer_requests USING btree (enterprise_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: enterprise_configuration_enterprise_id_f84fa14f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprise_configuration_enterprise_id_f84fa14f ON public.enterprise_configuration USING btree (enterprise_id);


--
-- Name: enterprise_customer_configuration_author_id_0102581a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprise_customer_configuration_author_id_0102581a ON public.enterprise_customer_configuration USING btree (author_id);


--
-- Name: otp_static_staticdevice_user_id_7f9cff2b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_staticdevice_user_id_7f9cff2b ON public.otp_static_staticdevice USING btree (user_id);


--
-- Name: otp_static_statictoken_device_id_74b7c7d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_device_id_74b7c7d1 ON public.otp_static_statictoken USING btree (device_id);


--
-- Name: otp_static_statictoken_token_d0a51866; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_token_d0a51866 ON public.otp_static_statictoken USING btree (token);


--
-- Name: otp_static_statictoken_token_d0a51866_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_token_d0a51866_like ON public.otp_static_statictoken USING btree (token varchar_pattern_ops);


--
-- Name: otp_totp_totpdevice_user_id_0fb18292; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_totp_totpdevice_user_id_0fb18292 ON public.otp_totp_totpdevice USING btree (user_id);


--
-- Name: token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like ON public.token_blacklist_outstandingtoken USING btree (jti varchar_pattern_ops);


--
-- Name: token_blacklist_outstandingtoken_user_id_83bc629a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_user_id_83bc629a ON public.token_blacklist_outstandingtoken USING btree (user_id);


--
-- Name: user_guide_owner_id_cded9d5a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_guide_owner_id_cded9d5a ON public.user_guide USING btree (owner_id);


--
-- Name: user_guide_uploads_user_guide_id_e5c39be2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_guide_uploads_user_guide_id_e5c39be2 ON public.user_guide_uploads USING btree (user_guide_id);


--
-- Name: accounts_account_groups accounts_account_gro_account_id_52f14852_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_gro_account_id_52f14852_fk_accounts_ FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_groups accounts_account_groups_group_id_7c6a6bd1_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_group_id_7c6a6bd1_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_user_permissions accounts_account_use_account_id_816f9bde_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_use_account_id_816f9bde_fk_accounts_ FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_user_permissions accounts_account_use_permission_id_24620205_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_use_permission_id_24620205_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: consumer_requests consumer_requests_customer_id_9915e7f1_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_customer_id_9915e7f1_fk_accounts_account_id FOREIGN KEY (customer_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: consumer_requests consumer_requests_enterprise_id_5e899e15_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_enterprise_id_5e899e15_fk_accounts_account_id FOREIGN KEY (enterprise_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprise_configuration enterprise_configura_enterprise_id_f84fa14f_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration
    ADD CONSTRAINT enterprise_configura_enterprise_id_f84fa14f_fk_accounts_ FOREIGN KEY (enterprise_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprise_customer_configuration enterprise_customer__author_id_0102581a_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration
    ADD CONSTRAINT enterprise_customer__author_id_0102581a_fk_accounts_ FOREIGN KEY (author_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_staticdevice otp_static_staticdevice_user_id_7f9cff2b_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdevice_user_id_7f9cff2b_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_statictoken otp_static_statictok_device_id_74b7c7d1_fk_otp_stati; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictok_device_id_74b7c7d1_fk_otp_stati FOREIGN KEY (device_id) REFERENCES public.otp_static_staticdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_user_id_0fb18292_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_user_id_0fb18292_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blac_token_id_3cc7fe56_fk_token_bla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blac_token_id_3cc7fe56_fk_token_bla FOREIGN KEY (token_id) REFERENCES public.token_blacklist_outstandingtoken(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outs_user_id_83bc629a_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outs_user_id_83bc629a_fk_accounts_ FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_guide user_guide_owner_id_cded9d5a_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide
    ADD CONSTRAINT user_guide_owner_id_cded9d5a_fk_accounts_account_id FOREIGN KEY (owner_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_guide_uploads user_guide_uploads_user_guide_id_e5c39be2_fk_user_guide_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads
    ADD CONSTRAINT user_guide_uploads_user_guide_id_e5c39be2_fk_user_guide_id FOREIGN KEY (user_guide_id) REFERENCES public.user_guide(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

