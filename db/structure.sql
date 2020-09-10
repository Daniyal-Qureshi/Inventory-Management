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

--
-- Name: inventory_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.inventory_statuses AS ENUM (
    'on_shelf',
    'shipped'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    recipient character varying NOT NULL,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    name character varying NOT NULL,
    access_code character varying(5) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventories (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    status public.inventory_statuses NOT NULL,
    order_id bigint
);


--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventories_id_seq OWNED BY public.inventories.id;


--
-- Name: inventory_status_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_status_changes (
    id bigint NOT NULL,
    inventory_id bigint NOT NULL,
    status_from public.inventory_statuses,
    status_to public.inventory_statuses NOT NULL,
    actor_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: inventory_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_status_changes_id_seq OWNED BY public.inventory_status_changes.id;


--
-- Name: order_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_line_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: order_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_line_items_id_seq OWNED BY public.order_line_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    ships_to_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: product_on_shelf_quantities; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.product_on_shelf_quantities AS
 SELECT i.product_id,
    count(i.product_id) AS quantity
   FROM public.inventories i
  WHERE (i.status = 'on_shelf'::public.inventory_statuses)
  GROUP BY i.product_id
  ORDER BY i.product_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: inventories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories ALTER COLUMN id SET DEFAULT nextval('public.inventories_id_seq'::regclass);


--
-- Name: inventory_status_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_status_changes ALTER COLUMN id SET DEFAULT nextval('public.inventory_status_changes_id_seq'::regclass);


--
-- Name: order_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_items ALTER COLUMN id SET DEFAULT nextval('public.order_line_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: inventories inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_status_changes inventory_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_status_changes
    ADD CONSTRAINT inventory_status_changes_pkey PRIMARY KEY (id);


--
-- Name: order_line_items order_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_line_items
    ADD CONSTRAINT order_line_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_employees_on_access_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employees_on_access_code ON public.employees USING btree (access_code);


--
-- Name: index_inventories_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_order_id ON public.inventories USING btree (order_id);


--
-- Name: index_inventories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_product_id ON public.inventories USING btree (product_id);


--
-- Name: index_inventories_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_status ON public.inventories USING btree (status);


--
-- Name: index_inventory_status_changes_on_actor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_status_changes_on_actor_id ON public.inventory_status_changes USING btree (actor_id);


--
-- Name: index_inventory_status_changes_on_inventory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_status_changes_on_inventory_id ON public.inventory_status_changes USING btree (inventory_id);


--
-- Name: index_order_line_items_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_line_items_on_order_id ON public.order_line_items USING btree (order_id);


--
-- Name: index_order_line_items_on_order_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_order_line_items_on_order_id_and_product_id ON public.order_line_items USING btree (order_id, product_id);


--
-- Name: index_order_line_items_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_line_items_on_product_id ON public.order_line_items USING btree (product_id);


--
-- Name: index_orders_on_ships_to_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_ships_to_id ON public.orders USING btree (ships_to_id);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_name ON public.products USING btree (name);


--
-- Name: inventory_status_changes fk_rails_72f1c09bf6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_status_changes
    ADD CONSTRAINT fk_rails_72f1c09bf6 FOREIGN KEY (inventory_id) REFERENCES public.inventories(id);


--
-- Name: orders fk_rails_7ccb04fb3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_7ccb04fb3b FOREIGN KEY (ships_to_id) REFERENCES public.addresses(id);


--
-- Name: inventories fk_rails_e94eb46135; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT fk_rails_e94eb46135 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: inventories fk_rails_ebe3a595e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT fk_rails_ebe3a595e1 FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: inventory_status_changes fk_rails_fa0a747687; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_status_changes
    ADD CONSTRAINT fk_rails_fa0a747687 FOREIGN KEY (actor_id) REFERENCES public.employees(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200901194536'),
('20200902183446'),
('20200903185412'),
('20200903190016'),
('20200908150851'),
('20200908151453'),
('20200908151850'),
('20200908224208'),
('20200909133724');


