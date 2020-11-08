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
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    email character varying(60) NOT NULL,
    verification_code integer,
    otp_verified boolean NOT NULL,
    is_admin boolean NOT NULL,
    is_active boolean NOT NULL,
    is_verified boolean NOT NULL,
    is_banned boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: admin_enterprise_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_enterprise_config (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id integer,
    updated_by_id integer
);


ALTER TABLE public.admin_enterprise_config OWNER TO postgres;

--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_enterprise_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_enterprise_config_id_seq OWNER TO postgres;

--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_enterprise_config_id_seq OWNED BY public.admin_enterprise_config.id;


--
-- Name: analytics_activitylog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analytics_activitylog (
    id integer NOT NULL,
    username_persistent character varying(200),
    requested_at timestamp with time zone NOT NULL,
    response_ms integer NOT NULL,
    elroi_id character varying(9) NOT NULL,
    path character varying(255) NOT NULL,
    view character varying(255),
    view_method character varying(255),
    remote_addr inet NOT NULL,
    host character varying(200) NOT NULL,
    method character varying(10) NOT NULL,
    query_params text,
    data text,
    response text,
    errors text,
    status_code integer,
    user_id integer,
    CONSTRAINT analytics_activitylog_response_ms_check CHECK ((response_ms >= 0)),
    CONSTRAINT analytics_activitylog_status_code_check CHECK ((status_code >= 0))
);


ALTER TABLE public.analytics_activitylog OWNER TO postgres;

--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analytics_activitylog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_activitylog_id_seq OWNER TO postgres;

--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analytics_activitylog_id_seq OWNED BY public.analytics_activitylog.id;


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
    request_form jsonb,
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
    customer_id integer,
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
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    elroi_id character varying(9),
    file character varying(100),
    email character varying(60),
    first_name character varying(40),
    last_name character varying(40),
    state_resident boolean NOT NULL,
    additional_fields jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


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
    logo character varying(100) NOT NULL,
    site_color character varying(7) NOT NULL,
    site_theme character varying(12) NOT NULL,
    background_image character varying(100) NOT NULL,
    website_launched_to character varying(255) NOT NULL,
    company_name character varying(255) NOT NULL,
    resident_state boolean NOT NULL,
    additional_configuration jsonb NOT NULL,
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
-- Name: enterprises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprises (
    id integer NOT NULL,
    email character varying(80) NOT NULL,
    elroi_id character varying(9),
    name character varying(255),
    web character varying(255),
    trial_start timestamp with time zone,
    trial_end timestamp with time zone,
    current_plan_end timestamp with time zone,
    is_active boolean NOT NULL,
    turn_off_date timestamp with time zone,
    allow_email_data boolean NOT NULL,
    allow_api_call boolean NOT NULL,
    payment jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_by_id integer,
    user_id integer
);


ALTER TABLE public.enterprises OWNER TO postgres;

--
-- Name: enterprises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprises_id_seq OWNER TO postgres;

--
-- Name: enterprises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprises_id_seq OWNED BY public.enterprises.id;


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
-- Name: admin_enterprise_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config ALTER COLUMN id SET DEFAULT nextval('public.admin_enterprise_config_id_seq'::regclass);


--
-- Name: analytics_activitylog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog ALTER COLUMN id SET DEFAULT nextval('public.analytics_activitylog_id_seq'::regclass);


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
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


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
-- Name: enterprises id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises ALTER COLUMN id SET DEFAULT nextval('public.enterprises_id_seq'::regclass);


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



--
-- Data for Name: accounts_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: accounts_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: admin_enterprise_config; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: analytics_activitylog; Type: TABLE DATA; Schema: public; Owner: postgres
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

INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (21, 'Can add user', 6, 'add_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (22, 'Can change user', 6, 'change_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (23, 'Can delete user', 6, 'delete_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (24, 'Can view user', 6, 'view_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (25, 'Can add enterprise', 7, 'add_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (26, 'Can change enterprise', 7, 'change_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (27, 'Can delete enterprise', 7, 'delete_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (28, 'Can view enterprise', 7, 'view_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (29, 'Can add customer', 8, 'add_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (30, 'Can change customer', 8, 'change_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (31, 'Can delete customer', 8, 'delete_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (32, 'Can view customer', 8, 'view_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (33, 'Can add user guide model', 9, 'add_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (34, 'Can change user guide model', 9, 'change_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (35, 'Can delete user guide model', 9, 'delete_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (36, 'Can view user guide model', 9, 'view_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (37, 'Can add user guide uploads', 10, 'add_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (38, 'Can change user guide uploads', 10, 'change_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (39, 'Can delete user guide uploads', 10, 'delete_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (40, 'Can view user guide uploads', 10, 'view_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (41, 'Can add enterprise configuration model', 11, 'add_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (42, 'Can change enterprise configuration model', 11, 'change_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (43, 'Can delete enterprise configuration model', 11, 'delete_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (44, 'Can view enterprise configuration model', 11, 'view_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (45, 'Can add customer configuration', 12, 'add_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (46, 'Can change customer configuration', 12, 'change_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (47, 'Can delete customer configuration', 12, 'delete_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (48, 'Can view customer configuration', 12, 'view_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (49, 'Can add consumer request', 13, 'add_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (50, 'Can change consumer request', 13, 'change_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (51, 'Can delete consumer request', 13, 'delete_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (52, 'Can view consumer request', 13, 'view_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (53, 'Can add admin enterprise config', 14, 'add_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (54, 'Can change admin enterprise config', 14, 'change_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (55, 'Can delete admin enterprise config', 14, 'delete_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (56, 'Can view admin enterprise config', 14, 'view_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (57, 'Can add Api logs', 15, 'add_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (58, 'Can change Api logs', 15, 'change_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (59, 'Can delete Api logs', 15, 'delete_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (60, 'Can view Api logs', 15, 'view_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (61, 'Can add TOTP device', 16, 'add_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (62, 'Can change TOTP device', 16, 'change_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (63, 'Can delete TOTP device', 16, 'delete_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (64, 'Can view TOTP device', 16, 'view_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (65, 'Can add static device', 17, 'add_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (66, 'Can change static device', 17, 'change_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (67, 'Can delete static device', 17, 'delete_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (68, 'Can view static device', 17, 'view_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (69, 'Can add static token', 18, 'add_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (70, 'Can change static token', 18, 'change_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (71, 'Can delete static token', 18, 'delete_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (72, 'Can view static token', 18, 'view_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (73, 'Can add blacklisted token', 19, 'add_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (74, 'Can change blacklisted token', 19, 'change_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (75, 'Can delete blacklisted token', 19, 'delete_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (76, 'Can view blacklisted token', 19, 'view_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (77, 'Can add outstanding token', 20, 'add_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (78, 'Can change outstanding token', 20, 'change_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (79, 'Can delete outstanding token', 20, 'delete_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (80, 'Can view outstanding token', 20, 'view_outstandingtoken');


--
-- Data for Name: consumer_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_content_type (id, app_label, model) VALUES (1, 'admin', 'logentry');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (2, 'auth', 'permission');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (3, 'auth', 'group');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (5, 'sessions', 'session');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (6, 'accounts', 'account');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (7, 'accounts', 'enterprise');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (8, 'accounts', 'customer');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (9, 'enterprise', 'userguidemodel');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (10, 'enterprise', 'userguideuploads');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (11, 'enterprise', 'enterpriseconfigurationmodel');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (12, 'enterprise', 'customerconfiguration');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (13, 'consumer_request', 'consumerrequest');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (14, 'elroi_admin', 'adminenterpriseconfig');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (15, 'analytics', 'activitylog');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (16, 'otp_totp', 'totpdevice');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (17, 'otp_static', 'staticdevice');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (18, 'otp_static', 'statictoken');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (19, 'token_blacklist', 'blacklistedtoken');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (20, 'token_blacklist', 'outstandingtoken');


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_migrations (id, app, name, applied) VALUES (1, 'contenttypes', '0001_initial', '2020-11-02 16:11:34.985524+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2020-11-02 16:11:35.01345+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (3, 'auth', '0001_initial', '2020-11-02 16:11:35.04745+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2020-11-02 16:11:35.088875+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (5, 'auth', '0003_alter_user_email_max_length', '2020-11-02 16:11:35.094859+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (6, 'auth', '0004_alter_user_username_opts', '2020-11-02 16:11:35.099846+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (7, 'auth', '0005_alter_user_last_login_null', '2020-11-02 16:11:35.10487+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (8, 'auth', '0006_require_contenttypes_0002', '2020-11-02 16:11:35.106877+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2020-11-02 16:11:35.112884+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (10, 'auth', '0008_alter_user_username_max_length', '2020-11-02 16:11:35.11883+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2020-11-02 16:11:35.123817+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (12, 'auth', '0010_alter_group_name_max_length', '2020-11-02 16:11:35.137779+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (13, 'auth', '0011_update_proxy_permissions', '2020-11-02 16:11:35.144465+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (14, 'accounts', '0001_initial', '2020-11-02 16:11:35.244704+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (15, 'admin', '0001_initial', '2020-11-02 16:11:35.335666+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (16, 'admin', '0002_logentry_remove_auto_add', '2020-11-02 16:11:35.3606+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (17, 'admin', '0003_logentry_add_action_flag_choices', '2020-11-02 16:11:35.368578+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (18, 'analytics', '0001_initial', '2020-11-02 16:11:35.391517+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (19, 'consumer_request', '0001_initial', '2020-11-02 16:11:35.452679+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (20, 'elroi_admin', '0001_initial', '2020-11-02 16:11:35.500375+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (21, 'enterprise', '0001_initial', '2020-11-02 16:11:35.610941+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (22, 'otp_static', '0001_initial', '2020-11-02 16:11:35.679433+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (23, 'otp_static', '0002_throttling', '2020-11-02 16:11:35.742283+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (24, 'otp_totp', '0001_initial', '2020-11-02 16:11:35.770594+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (25, 'otp_totp', '0002_auto_20190420_0723', '2020-11-02 16:11:35.807496+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (26, 'sessions', '0001_initial', '2020-11-02 16:11:35.821554+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (27, 'token_blacklist', '0001_initial', '2020-11-02 16:11:35.891649+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (28, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2020-11-02 16:11:35.919912+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (29, 'token_blacklist', '0003_auto_20171017_2007', '2020-11-02 16:11:35.943848+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (30, 'token_blacklist', '0004_auto_20171017_2013', '2020-11-02 16:11:35.970777+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (31, 'token_blacklist', '0005_remove_outstandingtoken_jti', '2020-11-02 16:11:35.990723+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (32, 'token_blacklist', '0006_auto_20171017_2113', '2020-11-02 16:11:36.009674+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (33, 'token_blacklist', '0007_auto_20171017_2214', '2020-11-02 16:11:36.06652+02');


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprise_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprise_customer_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprises; Type: TABLE DATA; Schema: public; Owner: postgres
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



--
-- Data for Name: user_guide; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_guide_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_groups_id_seq', 1, false);


--
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 1, false);


--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_user_permissions_id_seq', 1, false);


--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_enterprise_config_id_seq', 1, false);


--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analytics_activitylog_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.auth_permission_id_seq', 80, true);


--
-- Name: consumer_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consumer_requests_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 20, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 33, true);


--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_configuration_id_seq', 1, false);


--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_customer_configuration_id_seq', 1, false);


--
-- Name: enterprises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprises_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.token_blacklist_outstandingtoken_id_seq', 1, false);


--
-- Name: user_guide_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_id_seq', 1, false);


--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_uploads_id_seq', 1, false);


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
-- Name: admin_enterprise_config admin_enterprise_config_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_config_key_key UNIQUE (key);


--
-- Name: admin_enterprise_config admin_enterprise_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_config_pkey PRIMARY KEY (id);


--
-- Name: analytics_activitylog analytics_activitylog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog
    ADD CONSTRAINT analytics_activitylog_pkey PRIMARY KEY (id);


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
-- Name: customers customers_elroi_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_elroi_id_key UNIQUE (elroi_id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers customers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_key UNIQUE (user_id);


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
-- Name: enterprises enterprises_elroi_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_elroi_id_key UNIQUE (elroi_id);


--
-- Name: enterprises enterprises_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_email_key UNIQUE (email);


--
-- Name: enterprises enterprises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_pkey PRIMARY KEY (id);


--
-- Name: enterprises enterprises_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_user_id_key UNIQUE (user_id);


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
-- Name: admin_enterprise_config_created_by_id_fba789c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_created_by_id_fba789c9 ON public.admin_enterprise_config USING btree (created_by_id);


--
-- Name: admin_enterprise_config_key_050aa01c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_key_050aa01c_like ON public.admin_enterprise_config USING btree (key varchar_pattern_ops);


--
-- Name: admin_enterprise_config_updated_by_id_2cdf5cb5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_updated_by_id_2cdf5cb5 ON public.admin_enterprise_config USING btree (updated_by_id);


--
-- Name: analytics_activitylog_path_29cedd66; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_path_29cedd66 ON public.analytics_activitylog USING btree (path);


--
-- Name: analytics_activitylog_path_29cedd66_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_path_29cedd66_like ON public.analytics_activitylog USING btree (path varchar_pattern_ops);


--
-- Name: analytics_activitylog_requested_at_2d3a3500; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_requested_at_2d3a3500 ON public.analytics_activitylog USING btree (requested_at);


--
-- Name: analytics_activitylog_user_id_d7739206; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_user_id_d7739206 ON public.analytics_activitylog USING btree (user_id);


--
-- Name: analytics_activitylog_view_de64bb22; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_de64bb22 ON public.analytics_activitylog USING btree (view);


--
-- Name: analytics_activitylog_view_de64bb22_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_de64bb22_like ON public.analytics_activitylog USING btree (view varchar_pattern_ops);


--
-- Name: analytics_activitylog_view_method_31a9e8b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_method_31a9e8b2 ON public.analytics_activitylog USING btree (view_method);


--
-- Name: analytics_activitylog_view_method_31a9e8b2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_method_31a9e8b2_like ON public.analytics_activitylog USING btree (view_method varchar_pattern_ops);


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
-- Name: customers_elroi_id_31963595_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customers_elroi_id_31963595_like ON public.customers USING btree (elroi_id varchar_pattern_ops);


--
-- Name: customers_email_af8f39bb_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customers_email_af8f39bb_like ON public.customers USING btree (email varchar_pattern_ops);


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
-- Name: enterprises_elroi_id_0fc0e6d7_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_elroi_id_0fc0e6d7_like ON public.enterprises USING btree (elroi_id varchar_pattern_ops);


--
-- Name: enterprises_email_1d7a469d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_email_1d7a469d_like ON public.enterprises USING btree (email varchar_pattern_ops);


--
-- Name: enterprises_updated_by_id_d9cb6058; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_updated_by_id_d9cb6058 ON public.enterprises USING btree (updated_by_id);


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
-- Name: admin_enterprise_config admin_enterprise_con_created_by_id_fba789c9_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_con_created_by_id_fba789c9_fk_accounts_ FOREIGN KEY (created_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: admin_enterprise_config admin_enterprise_con_updated_by_id_2cdf5cb5_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_con_updated_by_id_2cdf5cb5_fk_accounts_ FOREIGN KEY (updated_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_activitylog analytics_activitylog_user_id_d7739206_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog
    ADD CONSTRAINT analytics_activitylog_user_id_d7739206_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: consumer_requests consumer_requests_customer_id_9915e7f1_fk_customers_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_customer_id_9915e7f1_fk_customers_id FOREIGN KEY (customer_id) REFERENCES public.customers(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: consumer_requests consumer_requests_enterprise_id_5e899e15_fk_enterprises_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_enterprise_id_5e899e15_fk_enterprises_id FOREIGN KEY (enterprise_id) REFERENCES public.enterprises(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: customers customers_user_id_28f6c6eb_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_28f6c6eb_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: enterprises enterprises_updated_by_id_d9cb6058_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_updated_by_id_d9cb6058_fk_accounts_account_id FOREIGN KEY (updated_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprises enterprises_user_id_c0761346_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_user_id_c0761346_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


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

