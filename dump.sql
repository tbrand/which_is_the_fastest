--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: concurrencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.concurrencies (
    id bigint NOT NULL,
    level numeric
);


ALTER TABLE public.concurrencies OWNER TO postgres;

--
-- Name: concurrencies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.concurrencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.concurrencies_id_seq OWNER TO postgres;

--
-- Name: concurrencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.concurrencies_id_seq OWNED BY public.concurrencies.id;

--
-- Name: engines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engines (
    id SERIAL PRIMARY KEY,
    label character varying UNIQUE
);

--
-- Name: frameworks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frameworks (
    id bigint NOT NULL,
    language_id bigint,
    label character varying
);


ALTER TABLE public.frameworks OWNER TO postgres;

--
-- Name: frameworks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.frameworks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.frameworks_id_seq OWNER TO postgres;

--
-- Name: frameworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.frameworks_id_seq OWNED BY public.frameworks.id;


--
-- Name: keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keys (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.keys OWNER TO postgres;

--
-- Name: keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keys_id_seq OWNER TO postgres;

--
-- Name: keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keys_id_seq OWNED BY public.keys.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metrics (
    framework_id bigint,
    value_id bigint,
    concurrency_id bigint,
    engine_id bigint
);


ALTER TABLE public.metrics OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."values" (
    id bigint NOT NULL,
    value double precision,
    key_id bigint
);


ALTER TABLE public."values" OWNER TO postgres;

--
-- Name: values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.values_id_seq OWNER TO postgres;

--
-- Name: values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.values_id_seq OWNED BY public."values".id;


--
-- Name: writable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writable (
    language_id bigint,
    framework_id bigint,
    engine_id bigint
);


ALTER TABLE public.writable OWNER TO postgres;

--
-- Name: concurrencies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concurrencies ALTER COLUMN id SET DEFAULT nextval('public.concurrencies_id_seq'::regclass);


--
-- Name: frameworks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frameworks ALTER COLUMN id SET DEFAULT nextval('public.frameworks_id_seq'::regclass);


--
-- Name: keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys ALTER COLUMN id SET DEFAULT nextval('public.keys_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."values" ALTER COLUMN id SET DEFAULT nextval('public.values_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	default_env	2020-02-09 14:44:04.669806	2020-02-09 14:44:04.669806
\.


--
-- Data for Name: concurrencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.concurrencies (id, level) FROM stdin;
\.


--
-- Data for Name: frameworks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.frameworks (id, language_id, label) FROM stdin;
\.


--
-- Data for Name: keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keys (id, label) FROM stdin;
\.


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.languages (id, label) FROM stdin;
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metrics (framework_id, value_id, concurrency_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20191014111447
20200209161533
\.


--
-- Data for Name: values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."values" (id, value, key_id) FROM stdin;
\.


--
-- Data for Name: writable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.writable (language_id, framework_id) FROM stdin;
\.


--
-- Name: concurrencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.concurrencies_id_seq', 1, false);


--
-- Name: frameworks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.frameworks_id_seq', 1, false);


--
-- Name: keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keys_id_seq', 1, false);


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.languages_id_seq', 1, false);


--
-- Name: values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.values_id_seq', 1, false);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: concurrencies concurrencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concurrencies
    ADD CONSTRAINT concurrencies_pkey PRIMARY KEY (id);


--
-- Name: frameworks frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frameworks
    ADD CONSTRAINT frameworks_pkey PRIMARY KEY (id);


--
-- Name: keys keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT keys_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: values values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."values"
    ADD CONSTRAINT values_pkey PRIMARY KEY (id);


--
-- Name: index_concurrencies_on_level; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_concurrencies_on_level ON public.concurrencies USING btree (level);


--
-- Name: index_frameworks_on_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_frameworks_on_language_id ON public.frameworks USING btree (language_id);


--
-- Name: index_frameworks_on_language_id_and_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_frameworks_on_language_id_and_label ON public.frameworks USING btree (language_id, label);


--
-- Name: index_keys_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_keys_on_label ON public.keys USING btree (label);


--
-- Name: index_languages_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_languages_on_label ON public.languages USING btree (label);


--
-- Name: index_metrics_on_concurrency_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_metrics_on_concurrency_id ON public.metrics USING btree (concurrency_id);


--
-- Name: index_metrics_on_framework_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_metrics_on_framework_id ON public.metrics USING btree (framework_id);


--
-- Name: index_metrics_on_value_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_metrics_on_value_id ON public.metrics USING btree (value_id);
CREATE INDEX index_metrics_on_engine_id ON public.metrics USING btree (engine_id);


--
-- Name: index_values_on_key_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_values_on_key_id ON public."values" USING btree (key_id);


--
-- Name: index_writable_on_framework_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_writable_on_framework_id ON public.writable USING btree (framework_id);


--
-- Name: index_writable_on_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_writable_on_language_id ON public.writable USING btree (language_id);


--
-- PostgreSQL database dump complete
--

